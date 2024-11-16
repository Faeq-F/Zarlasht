//// Chat creation

import gleam/int
import glen/ws
import pages/set_name.{set_name_page}
import socket_state.{type Event, type State, State}
import utils.{chat_exists}

/// Creates a new chat & updates the WebSocket state
///
pub fn on_create_chat(conn: ws.WebsocketConn(Event)) -> State {
  let chat_code = generate_chat_code()
  let _ = ws.send_text(conn, set_name_page())
  State(chat_code, "")
}

/// Creates a unique code for the chat
///
fn generate_chat_code() -> Int {
  let code = int.random(999_999_999_999_999)
  case chat_exists(code) {
    False -> code
    _ -> generate_chat_code()
  }
}
