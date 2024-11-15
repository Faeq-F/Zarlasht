import birl.{now, to_naive_date_string, to_naive_time_string}
import gleam/dynamic
import gleam/int
import gleam/json.{object, string, to_string}
import glen/ws
import lustre/element
import pages/chat.{message, send_message_form}
import socket_state.{type Event, type State}
import utils.{db_set, valkey_publish}

pub fn publish_message(
  conn: ws.WebsocketConn(Event),
  state: State,
  sent_message: String,
) {
  let sent_message_html =
    message(
      sent_message,
      state.username,
      to_naive_date_string(now()),
      to_naive_time_string(now()),
      False,
    )

  db_set(int.to_string(state.chat_code), dynamic.from(sent_message_html))

  let _ =
    ws.send_text(
      conn,
      message(
        sent_message,
        state.username,
        to_naive_date_string(now()),
        to_naive_time_string(now()),
        True,
      ),
    )

  valkey_publish(
    int.to_string(state.chat_code),
    to_string(
      object([
        #("username", string(state.username)),
        #("html", string(sent_message_html)),
      ]),
    ),
  )

  let _ = ws.send_text(conn, send_message_form() |> element.to_string)
}
