//// Joining a game that has already been created

import gleam/int
import glen/ws
import pages/set_name.{set_name_page}
import pages/to_join_game.{join_game_page, wrong_code}
import socket_state.{type Event, type State, State}
import state.{add_socket, for_all_sockets, get_json_value}

/// Asked to join a game
///
/// Sends the user to the `join_game_page`
///
pub fn on_to_join_game(conn: ws.WebsocketConn(Event)) -> State {
  let _ = ws.send_text(conn, join_game_page())
  State(-1, "Neither")
}

/// After the game code has been inputted on the join page
///
/// Checks if the game exists and sends them to the `set_name_page`
///
pub fn on_join_game(
  text_message: String,
  conn: ws.WebsocketConn(Event),
) -> State {
  case int.parse(get_json_value(text_message, "gameCode")) {
    Ok(code) -> {
      case add_socket(conn, code) {
        0 -> {
          for_all_sockets(code, fn(socket, _player, _name) {
            let _ = ws.send_text(socket, set_name_page())
            Nil
          })
          State(code, "O")
        }
        _ -> {
          let _ = ws.send_text(conn, wrong_code())
          State(-1, "Neither")
        }
      }
    }
    _ -> {
      let _ = ws.send_text(conn, wrong_code())
      State(-1, "Neither")
    }
  }
}
