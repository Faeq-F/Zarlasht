import gleam/int
import glen/ws
import pages/chat.{message}
import socket_state.{type Event, type State}
import utils.{valkey_publish}

pub fn publish_message(
  conn: ws.WebsocketConn(Event),
  state: State,
  sent_message: String,
) {
  //save to db
  let _ = ws.send_text(conn, message(sent_message, True))

  valkey_publish(
    int.to_string(state.chat_code),
    "\"username\":\""
      <> state.username
      <> "\", \"html\":\""
      <> message(sent_message, False)
      <> "\"",
  )
  //username
}
