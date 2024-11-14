import birl.{now, to_naive_date_string, to_naive_time_string}
import gleam/int
import gleam/json.{object, string, to_string}
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
        #(
          "html",
          string(message(
            sent_message,
            state.username,
            to_naive_date_string(now()),
            to_naive_time_string(now()),
            False,
          )),
        ),
      ]),
    ),
  )
}
