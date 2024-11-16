//// Joining a chat that has already been created

import gleam/int
import glen/ws
import pages/set_name.{set_name_page}
import pages/to_join_chat.{join_chat_page, wrong_code}
import socket_state.{type Event, type State, State}
import utils.{chat_exists, get_json_value}

/// Joining chat
///
pub fn on_to_join_chat(conn: ws.WebsocketConn(Event)) -> State {
  let _ = ws.send_text(conn, join_chat_page())
  State(-1, "")
}

/// After chat code is inputted on join screen
///
pub fn on_join_chat(
  text_message: String,
  conn: ws.WebsocketConn(Event),
) -> State {
  case int.parse(get_json_value(text_message, "chatCode")) {
    Ok(code) -> {
      case chat_exists(code) {
        True -> {
          let _ = ws.send_text(conn, set_name_page())
          State(code, "")
        }
        _ -> {
          let _ = ws.send_text(conn, wrong_code())
          State(-1, "")
        }
      }
    }
    _ -> {
      let _ = ws.send_text(conn, wrong_code())
      State(-1, "")
    }
  }
}
