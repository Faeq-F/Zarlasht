import app/actors/actor_types.{
  type UserSocket, type WebsocketActorState, AddParticipant, WebsocketActorState,
}
import app/pages/chat.{chat_page}
import app/pages/to_join_chat.{join_chat_page, wrong_code}
import gleam/dict
import gleam/erlang/process
import gleam/int.{to_string}
import gleam/json.{int}
import juno
import mist

//----------------------------------------------------------------
// Before game code input

pub fn on_to_join_chat(user: UserSocket) -> WebsocketActorState {
  let assert Ok(_) = mist.send_text_frame(user.socket, join_chat_page())
  user.state
}

//----------------------------------------------------------------
// After game code input

pub fn on_join_chat(message: String, user: UserSocket) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(chat_code)) = message_dict |> dict.get("chatCode")
  case int.parse(chat_code) {
    Ok(code) -> {
      process.send(
        user.state.director_subject,
        AddParticipant(code, user.state.name, user.state.ws_subject),
      )
      let assert Ok(_) =
        mist.send_text_frame(
          user.socket,
          chat_page(user.state.chat_code |> to_string),
        )
      WebsocketActorState(..user.state, chat_code: code)
    }

    _ -> {
      let assert Ok(_) = mist.send_text_frame(user.socket, wrong_code())
      user.state
    }
  }
}
