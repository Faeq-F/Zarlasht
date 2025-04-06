import app/actors/actor_types.{
  type GameActorState, type PlayerSocket, type WebsocketActorState, AddedName,
  Chat, Dice, GameActorState, GameStarted, GameState, GetParticipants, GetState,
  GetStateWS, Home, Map, Message, Participants, Player, SendToClient, StateWS,
  UpdateState, WebsocketActorState,
}
import app/pages/chat.{chat, chat_messages, chat_section, send_message_section}
import app/pages/created_game.{info_error_player_count, info_error_setting_name}
import app/pages/game as game_page
import app/pages/map.{map}
import app/pages/roll_die.{roll_die}
import birl
import gleam/dict
import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import gleam/otp/actor
import juno
import lustre/element
import mist

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
