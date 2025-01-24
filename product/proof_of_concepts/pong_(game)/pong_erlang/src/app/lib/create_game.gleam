//// Game creation

import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueUser, WebsocketActorState,
}

import carpenter/table
import gleam/erlang/process
import gleam/int
import logging.{Info}

/// Creates a new game & updates the WebSocket state
///
pub fn on_create_game(player: PlayerSocket) -> WebsocketActorState {
  // let game_code = generate_game_code(player)
  process.send(
    player.state.director_subject,
    EnqueueUser(player.state.ws_subject),
  )
  player.state
}

/// Creates a unique code for the game
///
fn generate_game_code(player: PlayerSocket) -> Int {
  todo
  // let assert Ok(games) = table.ref("games")
  // let game_code = case int.random(9999) {
  //   0 -> 1
  //   code -> code
  // }
  // case games |> table.lookup(game_code) {
  //   [] -> {
  //     games
  //     |> table.insert([#(game_code, "Game created")])
  //     logging.log(Info, "New game created; " <> int.to_string(game_code))
  //     game_code
  //   }
  //   _ -> generate_game_code(player)
  // }
}
