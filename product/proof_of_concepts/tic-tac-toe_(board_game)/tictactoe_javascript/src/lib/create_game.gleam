import gleam/int
import glen/ws
import socket_state.{type Event, type State, State}
import state.{add_game}

pub fn on_create_game(conn: ws.WebsocketConn(Event)) -> State {
  let game_code = generate_game_code(conn)
  State(game_code, "X")
}

fn generate_game_code(conn: ws.WebsocketConn(Event)) -> Int {
  let game_code = int.random(9999)
  case add_game(game_code, conn) {
    0 -> game_code
    _ -> generate_game_code(conn)
  }
}
