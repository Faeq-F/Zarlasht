//// Chat Actions

import app/actors/actor_types.{
  type UserSocket, type WebsocketActorState, SentMessage,
}
import app/pages/chat.{send_message_form}
import gleam/dict
import gleam/erlang/process
import juno
import lustre/element.{to_string}
import mist

/// Sending a message
///
pub fn on_send_message(
  text_message: String,
  player: UserSocket,
) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(text_message, [])
  let assert Ok(juno.String(message_text)) = message_dict |> dict.get("message")

  case message_text {
    "" -> {
      player.state
      // Do nothing as message is empty
    }
    _ -> {
      process.send(
        player.state.director_subject,
        SentMessage(player.state.chat_code, message_text, player.state.name),
      )
      let assert Ok(_) =
        mist.send_text_frame(player.socket, send_message_form() |> to_string)
      player.state
    }
  }
}
