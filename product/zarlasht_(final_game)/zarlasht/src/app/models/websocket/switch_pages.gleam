//// The handlers for switching pages in the game

import app/actors/actor_types.{
  type GameActorState, type WebsocketActorState, Chat, Dice, GameActorState,
  GameState, GetState, Home, Map, UpdateState, WebsocketActorState,
}

import app/pages/chat.{chat}
import app/pages/game as game_page
import app/pages/map.{map}
import app/pages/roll_die.{roll_die}
import gleam/dict
import gleam/erlang/process
import gleam/option.{Some}
import mist

/// The handler for switching to the map page
///
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

/// The handler for switching to the home page
///
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

/// The handler for switching to the chats page
///
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

/// The handler for switching to the dice roll page
///
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
