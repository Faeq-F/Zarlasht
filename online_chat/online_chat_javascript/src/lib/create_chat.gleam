//// Chat creation

import gleam/int
import glen/ws
import pages/pubsub_test.{pubsub_test_page}
import socket_state.{type Event, type State, State}
import utils.{chat_exists, valkey_subscribe}

/// Creates a new chat & updates the WebSocket state
///
pub fn on_create_chat(conn: ws.WebsocketConn(Event)) -> State {
  let chat_code = generate_chat_code()
  valkey_subscribe(int.to_string(chat_code), conn)
  let _ = ws.send_text(conn, pubsub_test_page())
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
