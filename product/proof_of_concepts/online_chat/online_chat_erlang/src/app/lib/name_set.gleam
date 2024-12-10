import app/actors/actor_types.{
  type UserSocket, type WebsocketActorState, AddParticipant, WebsocketActorState,
}
import app/pages/chat.{chat_page}
import app/pages/set_name.{empty_name}
import gleam/dict
import gleam/erlang/process
import gleam/int.{to_string}
import juno
import mist

pub fn set_name(message: String, user: UserSocket) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(name)) = message_dict |> dict.get("name")
  case name {
    "" -> {
      let assert Ok(_) = mist.send_text_frame(user.socket, empty_name())
      user.state
    }
    _ -> {
      process.send(
        user.state.director_subject,
        AddParticipant(user.state.chat_code, name, user.state.ws_subject),
      )
      let assert Ok(_) =
        mist.send_text_frame(
          user.socket,
          chat_page(user.state.chat_code |> to_string),
        )
      WebsocketActorState(..user.state, name: name)
    }
  }
}
