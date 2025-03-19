//// Game creation

import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueParticipant, Player,
  SwapColors, WebsocketActorState,
}

import app/pages/created_game.{created_game_page}
import carpenter/table
import gleam/dict
import gleam/erlang/process
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/string.{drop_end}
import juno
import logging.{Info}
import mist

/// Creates a new game & updates the WebSocket state
///
pub fn on_create_game(player: PlayerSocket) -> WebsocketActorState {
  let game_code = generate_game_code()
  process.send(
    player.state.director_subject,
    EnqueueParticipant(
      game_code,
      Player(1, "", "", 10, 1),
      player.state.ws_subject,
    ),
  )
  // let assert Ok(_) = - dont do this here
  //   mist.send_text_frame(player.socket, created_game_page(game_code, player))
  WebsocketActorState(..player.state, player: Player(1, "", "", 10, 1))
}

/// Creates a unique code for the game
///
fn generate_game_code() -> Int {
  let assert Ok(waiting_games) = table.ref("waiting_games")
  let assert Ok(game_code) =
    // generate a random number between 1000 (inclusive), and 10000 (exclusive)
    float.floor(float.random() *. { 10_000.0 -. 1000.0 +. 1.0 }) +. 1000.0
    |> float.to_string
    |> drop_end(2)
    |> int.parse
  //4 character game codes are purely aesthetic - no real requirement
  // Games with the same codes can exist;
  // They just cannot be waiting for a joining player at the same time
  case waiting_games |> table.lookup(game_code) {
    [] -> {
      waiting_games
      |> table.insert([#(game_code, "Waiting for players to join")])
      logging.log(Info, "New game created; " <> int.to_string(game_code))
      game_code
    }
    _ -> generate_game_code()
  }
}

pub fn update_colors(message: String, player: PlayerSocket) {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.Array(colors)) = message_dict |> dict.get("colors")
  let colors =
    colors
    |> list.map(fn(x) {
      let assert juno.String(color) = x
      color
    })
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, SwapColors(colors, game_subject))
  player.state
}
