import app/actors/actor_types.{
  type UserSocket, type WebsocketActorState, AddParticipant, WebsocketActorState,
}

import app/pages/set_name.{set_name_page}
import gleam/erlang/process
import gleam/int
import mist

pub fn on_create_chat(user: UserSocket) -> WebsocketActorState {
  let chat_code = generate_chat_code()
  process.send(
    user.state.director_subject,
    AddParticipant(chat_code, user.state.name, user.state.ws_subject),
  )
  let assert Ok(_) = mist.send_text_frame(user.socket, set_name_page())
  WebsocketActorState(..user.state, chat_code: chat_code)
}

fn generate_chat_code() -> Int {
  case int.random(9999) {
    0 -> 1
    code -> code
  }
}
