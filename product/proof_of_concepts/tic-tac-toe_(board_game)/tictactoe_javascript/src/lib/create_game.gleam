//// Game creation

import gleam/int
import glen/ws
import pages/created_game.{created_game_page}
import socket_state.{type Event, type State, State}
import state.{add_game}

/// Creates a new game & updates the WebSocket state
///
pub fn on_create_game(conn: ws.WebsocketConn(Event)) -> State {
  let game_code = generate_game_code(conn)
  let _ = ws.send_text(conn, created_game_page(game_code))
  State(game_code, "X")
}

/// Creates a unique code for the game
///
fn generate_game_code(conn: ws.WebsocketConn(Event)) -> Int {
  let game_code = int.random(9999)
  case add_game(game_code, conn) {
    0 -> game_code
    _ -> generate_game_code(conn)
  }
}
