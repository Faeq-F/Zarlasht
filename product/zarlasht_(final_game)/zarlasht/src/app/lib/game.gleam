import app/actors/actor_types.{
  type GameActorState, type PlayerSocket, type WebsocketActorState, AddedName,
  Chat, Dice, GameActorState, GameStarted, GameState, GetParticipants, GetState,
  GetStateWS, Home, Map, Message, Participants, Player, SendToClient, StateWS,
  UpdateState, WebsocketActorState,
}
import app/pages/chat.{chat, chat_section}
import app/pages/created_game.{info_error_player_count, info_error_setting_name}
import birl
import gleam/dict
import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import gleam/otp/actor
import juno
import lustre/element
import mist

pub fn start_game(player: PlayerSocket) {
  let assert Participants(participants) =
    process.call_forever(player.state.director_subject, GetParticipants(
      _,
      player.state.game_code,
    ))
  //TODO - DEPLOYMENT
  //change to 5 in deployment
  case participants |> list.length() == 2 {
    True -> {
      //check they have all set their name
      case
        participants
        |> list.filter(fn(pl) { { pl.0 }.name == "Setting name..." })
        |> list.length()
        == 0
      {
        True -> {
          // tell everyone to go to the game page
          // & delete game from waiting table & director state
          process.send(
            player.state.director_subject,
            GameStarted(player.state.game_code),
          )
          Nil
        }
        _ -> {
          let assert Ok(_) =
            mist.send_text_frame(
              player.socket,
              info_error_setting_name() |> element.to_string,
            )
          Nil
        }
      }
      Nil
    }
    _ -> {
      //send them need 5 players
      let assert Ok(_) =
        mist.send_text_frame(
          player.socket,
          info_error_player_count() |> element.to_string,
        )
      Nil
    }
  }
  player.state
}

pub fn send_message(
  player_to_send_to: String,
  message: String,
  player: PlayerSocket,
) {
  let assert Ok(player_to_send_to) = int.parse(player_to_send_to)
  let time = birl.now() |> birl.to_naive_time_string()
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(message_text)) =
    message_dict |> dict.get("messageText")

  let assert Some(game_subject) = player.state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)

  // update game state (correct dict)
  case player_to_send_to == player.state.player.number {
    True -> {
      //allies
      let assert Ok(key) =
        game_state.ally_chats
        |> dict.keys()
        |> list.find(fn(key) { key |> list.contains(player_to_send_to) })
      let assert Ok(messages) = game_state.ally_chats |> dict.get(key)

      let sender = player.state.player.number
      let name = player.state.player.name
      let color = player.state.player.color
      let messages =
        messages
        |> list.append([Message(sender, name, color, time, message_text)])

      let new_game_state =
        GameActorState(
          ..game_state,
          ally_chats: game_state.ally_chats |> dict.insert(key, messages),
        )

      process.send(game_subject, UpdateState(new_game_state))
      // update pages being viewed
      //update_chat_pages_in_view(player_to_send_to, new_game_state)
    }
    _ -> {
      //specific player
      let assert Ok(key) =
        game_state.player_chats
        |> dict.keys()
        |> list.find(fn(key) {
          { key.0 == player_to_send_to && key.1 == player.state.player.number }
          || {
            key.0 == player.state.player.number && key.1 == player_to_send_to
          }
        })
      let assert Ok(messages) = game_state.player_chats |> dict.get(key)

      let sender = player.state.player.number
      let name = player.state.player.name
      let color = player.state.player.color
      let messages =
        messages
        |> list.append([Message(sender, name, color, time, message_text)])

      let new_game_state =
        GameActorState(
          ..game_state,
          player_chats: game_state.player_chats |> dict.insert(key, messages),
        )

      process.send(game_subject, UpdateState(new_game_state))
      // update pages being viewed
      //update_chat_pages_in_view(player_to_send_to, new_game_state)
    }
  }
  player.state
}

//TODO - check if handled allies correctly
fn update_chat_pages_in_view(player_to_send_to: Int, game_state: GameActorState) {
  game_state.pages_in_view
  |> dict.keys()
  |> list.each(fn(key) {
    let assert Ok(page) = game_state.pages_in_view |> dict.get(key)
    case page == Chat(player_to_send_to) {
      True -> {
        let assert Ok(player_viewing) =
          game_state.participants
          |> list.find(fn(player) { { player.0 }.number == key })

        //issue - call forever not ending
        let assert StateWS(player_viewing_state) =
          process.call(player_viewing.1, GetStateWS, 5000)

        echo player_viewing_state

        process.send(
          player_viewing.1,
          SendToClient(
            chat_section(player_to_send_to, player_viewing_state, game_state)
            |> element.to_string,
          ),
        )
        Nil
      }
      _ -> Nil
    }
  })
}

import gleam/int

pub fn switch_chat(
  player_to_chat_to: String,
  state: WebsocketActorState,
  conn: mist.WebsocketConnection,
) {
  let assert Ok(player_to_chat_to) = int.parse(player_to_chat_to)
  let assert Some(game_subject) = state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)

  process.send(
    game_subject,
    UpdateState(
      GameActorState(
        ..game_state,
        pages_in_view: game_state.pages_in_view
          |> dict.insert(state.player.number, Chat(player_to_chat_to)),
      ),
    ),
  )

  let assert Ok(_) =
    mist.send_text_frame(
      conn,
      chat_section(player_to_chat_to, state, game_state)
        |> element.to_string,
    )
  state
}

import app/pages/game as game_page
import app/pages/map.{map}
import app/pages/roll_die.{roll_die}

pub fn go_to_map(state: WebsocketActorState, conn: mist.WebsocketConnection) {
  let assert Some(game_subject) = state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)
  process.send(
    game_subject,
    UpdateState(
      GameActorState(
        ..game_state,
        pages_in_view: game_state.pages_in_view
          |> dict.insert(state.player.number, Map),
      ),
    ),
  )
  let assert Ok(_) = mist.send_text_frame(conn, map(state, game_state))
  state
}

pub fn go_to_home(state: WebsocketActorState, conn: mist.WebsocketConnection) {
  let assert Some(game_subject) = state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)
  process.send(
    game_subject,
    UpdateState(
      GameActorState(
        ..game_state,
        pages_in_view: game_state.pages_in_view
          |> dict.insert(state.player.number, Home),
      ),
    ),
  )
  let assert Ok(_) = mist.send_text_frame(conn, game_page.game(state.player))
  state
}

pub fn go_to_chats(state: WebsocketActorState, conn: mist.WebsocketConnection) {
  let assert Some(game_subject) = state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)
  process.send(
    game_subject,
    UpdateState(
      GameActorState(
        ..game_state,
        pages_in_view: game_state.pages_in_view
          |> dict.insert(state.player.number, Chat(state.player.number)),
      ),
    ),
  )
  let assert Ok(_) = mist.send_text_frame(conn, chat(state))
  state
}

pub fn go_to_dice_roll(
  state: WebsocketActorState,
  conn: mist.WebsocketConnection,
) {
  let assert Some(game_subject) = state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)
  process.send(
    game_subject,
    UpdateState(
      GameActorState(
        ..game_state,
        pages_in_view: game_state.pages_in_view
          |> dict.insert(state.player.number, Dice),
      ),
    ),
  )
  let assert Ok(_) = mist.send_text_frame(conn, roll_die(state.player))
  state
}
