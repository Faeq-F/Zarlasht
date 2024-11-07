//// Handling WebSocket events

import gleam/int
import gleam/io
import gleam/javascript/promise.{type Promise}
import glen.{type Request, type Response}
import glen/ws
import lib/create_chat.{on_create_chat}
import lib/join_chat.{on_to_join_chat}
import socket_state.{type Event, type State, State}
import utils.{get_json_value, valkey_publish}

/// Establishes a WebSocket connection for the client on the `/init_socket` endpoint
///
pub fn init_socket(req: Request) -> Promise(Response) {
  use _ <- glen.websocket(
    req,
    on_open: open_socket,
    on_close: close_socket,
    on_event: event_socket,
  )
  Nil
}

/// The function that runs when a WebSocket connects
///
/// Logs `"A Socket Connected"` & sets the Socket's state to `-1` for the `chat_code` and `""` for the `username`
///
fn open_socket(_conn: ws.WebsocketConn(Event)) -> State {
  io.debug("A Socket Connected")
  State(-1, "")
}

/// The function that runs when a WebSocket disconnects
///
/// Logs `"A Socket Disconnected"`
///
fn close_socket(_state: State) -> Nil {
  io.debug("A Socket Disconnected")
  Nil
}

/// The function that runs when any message is recieved from a WebSocket (including Events that were fired)
///
/// `"ping"`s are responded with `"pong"`s
///
fn event_socket(
  conn: ws.WebsocketConn(Event),
  state: State,
  msg: ws.WebsocketMessage(Event),
) -> State {
  io.debug("WebSocket message recieved:")
  io.debug(msg)
  case msg {
    ws.Text("ping") -> {
      let _ = ws.send_text(conn, "pong")
      state
    }

    ws.Text(text_message) -> {
      case
        get_json_value(get_json_value(text_message, "HEADERS"), "HX-Trigger")
      {
        "create" -> {
          on_create_chat(conn)
        }

        "join" -> {
          on_to_join_chat()
        }

        "test" -> {
          valkey_publish(int.to_string(state.chat_code), "Testing Pub /Sub")
          state
        }

        _ -> {
          io.debug("Unknown Trigger")
          state
        }
      }
    }

    _ -> {
      io.debug("Unknown message")
      state
    }
  }
}
