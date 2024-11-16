import gleam/int
import glen/ws
import pages/chat.{chat_page}
import socket_state.{type Event, type State, State}
import utils.{get_json_value, send_old_messages, valkey_subscribe}

pub fn on_set_name(
  text_message: String,
  conn: ws.WebsocketConn(Event),
  state: State,
) -> State {
  let name = get_json_value(text_message, "name")
  valkey_subscribe(int.to_string(state.chat_code), conn)
  let _ = ws.send_text(conn, chat_page(int.to_string(state.chat_code)))

  send_old_messages(state.chat_code, conn)

  State(state.chat_code, name)
}
