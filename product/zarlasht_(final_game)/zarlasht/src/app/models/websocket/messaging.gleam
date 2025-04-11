//// In-game messages related handlers

import app/actors/actor_types.{
  type GameActorState, type PlayerSocket, type WebsocketActorState, Chat,
  GameActorState, GameState, GetState, Message, UpdateState, WebsocketActorState,
}

import app/pages/chat.{chat_messages, chat_section, send_message_section}
import birl
import gleam/dict
import gleam/erlang/process
import gleam/int
import gleam/list
import gleam/option.{Some}
import juno
import lustre/element
import mist

/// The handler for sending a message to a player
///
pub fn send_message(
  player_to_send_to: String,
  message: String,
  player: PlayerSocket,
) {
  // -- clear field
  let assert Ok(to_chat_to) = int.parse(player_to_send_to)
  let assert Ok(_) =
    mist.send_text_frame(
      player.socket,
      send_message_section(to_chat_to) |> element.to_string,
    )

  // -- send message

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
      // update pages being viewed (event-driven)
      //update_chat_pages_in_view(player_to_send_to, new_game_state)
    }
  }
  player.state
}

/// The handler for updating the chat messages
///
pub fn update_chat_messages(
  state: WebsocketActorState,
  conn: mist.WebsocketConnection,
) {
  let assert Some(game_subject) = state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)
  let assert Ok(Chat(chatting_to)) =
    game_state.pages_in_view |> dict.get(state.player.number)
  let assert Ok(_) =
    mist.send_text_frame(
      conn,
      chat_messages(chatting_to, state, game_state) |> element.to_string,
    )
  Nil
}

/// The handler for switching to a different chat in the game
///
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
