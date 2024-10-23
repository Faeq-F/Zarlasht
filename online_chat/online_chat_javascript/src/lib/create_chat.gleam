//// Chat creation

import gleam/int
import socket_state.{type State, State}

/// Creates a new chat & updates the WebSocket state
///
pub fn on_create_chat() -> State {
  let chat_code = generate_chat_code()
  State(chat_code, "")
}

/// Creates a unique code for the chat
///
fn generate_chat_code() -> Int {
  int.random(9999)
}
