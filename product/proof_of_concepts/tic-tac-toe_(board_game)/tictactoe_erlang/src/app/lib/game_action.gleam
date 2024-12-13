//// Game actions

import app/actors/actor_types.{
  type GameActorState, type Player, type PlayerSocket, type WebsocketActorState,
  BoxClick, GameActorState, GameState, Message, ResetGame,
}
import app/pages/game.{send_message_form}
import gleam/dict
import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import juno
import lustre/element.{to_string}
import mist

/// Updates the game state when a player clicks on a box
///
/// (Just sends the game actor a message to do this)
///
pub fn on_box_click(box: Int, state: WebsocketActorState) -> WebsocketActorState {
  let assert Some(game_subject) = state.game_subject
  process.send(game_subject, BoxClick(state.player, box))
  state
}

/// Produces a game state with the box that was clicked, marked
///
pub fn new_game_state(
  state: GameActorState,
  player: Player,
  box_index: Int,
) -> GameActorState {
  let before_box = { state.game_state.state |> list.split(box_index) }.0
  let assert Ok(after_box) =
    list.rest({ state.game_state.state |> list.split(box_index) }.1)
  let new_list = list.flatten([before_box, [player], after_box])

  GameActorState(
    ..state,
    game_state: GameState(..state.game_state, state: new_list),
  )
}

/// Distributes the message to the other player
///
/// (Just sends the game actor a message to do this)
///
pub fn on_send_message(
  text_message: String,
  player: PlayerSocket,
) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(text_message, [])
  let assert Ok(juno.String(message_text)) = message_dict |> dict.get("message")

  case message_text {
    "" -> {
      player.state
      // Do nothing as message is empty
    }
    _ -> {
      let assert Some(game_subject) = player.state.game_subject
      process.send(game_subject, Message(message_text, player.state.player))
      let assert Ok(_) =
        mist.send_text_frame(player.socket, send_message_form() |> to_string)
      player.state
    }
  }
}

/// Resets the game state when a player wishes to replay
///
/// (Just sends the game actor a message to do this)
///
/// Lets the other player (one who didn't go first last time) take the first turn
///
pub fn on_replay_game(player: PlayerSocket) -> WebsocketActorState {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, ResetGame)
  player.state
}
