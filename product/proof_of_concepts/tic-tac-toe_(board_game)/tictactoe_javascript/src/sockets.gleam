//// Handling WebSocket events

import gleam/int
import gleam/io
import gleam/javascript/promise.{type Promise}
import glen.{type Request, type Response}
import glen/ws
import lib/create_game.{on_create_game}
import lib/game.{on_box_click, on_replay_game, on_send_message}
import lib/join_game.{on_join_game, on_to_join_game}
import lib/set_name.{on_set_name}
import lustre/attribute
import lustre/element
import lustre/element/html
import socket_state.{type Event, type State, State}
import state.{for_all_sockets, get_json_value, remove_socket}

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
/// Logs `"A Socket Connected"` & sets the Socket's state to `-1` for the `chat_code` and `"Neither"` for the `player`
///
fn open_socket(_conn: ws.WebsocketConn(Event)) -> State {
  io.debug("A Socket Connected")
  State(-1, "Neither")
}

/// The function that runs when a WebSocket disconnects
///
/// Logs `"A Socket Disconnected"` and forces the opponent to disconnect after an error message
///
fn close_socket(state: State) -> Nil {
  io.debug("A Socket Disconnected")
  case remove_socket(state.game_code, state.player) {
    1 -> {
      let _ =
        for_all_sockets(state.game_code, fn(socket, _player, _name) {
          let _ =
            ws.send_text(
              socket,
              html.div([attribute.id("page")], [
                html.script(
                  [],
                  "alert('Your opponent disconnected!'); window.onbeforeunload = null; location.reload();",
                ),
              ])
                |> element.to_string,
            )
          Nil
        })
      Nil
    }
    _ -> {
      Nil
    }
  }
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
      let _ =
        for_all_sockets(state.game_code, fn(socket, _player, _name) {
          let _ = ws.send_text(socket, "pong")
          Nil
        })
      state
    }

    ws.Text(text_message) -> {
      case
        get_json_value(get_json_value(text_message, "HEADERS"), "HX-Trigger")
      {
        "create" -> {
          on_create_game(conn)
        }

        "join" -> {
          on_to_join_game(conn)
        }

        "join-game-form" -> {
          on_join_game(text_message, conn)
        }

        "set-name-form" -> {
          on_set_name(text_message, conn, state)
        }

        "send_message_form" -> {
          on_send_message(text_message, conn, state)
        }

        "replay_button" -> {
          on_replay_game(state)
        }

        text -> {
          case int.parse(text) {
            Ok(number) -> {
              case number >= 0 && number <= 8 {
                True -> {
                  on_box_click(number, state)
                }
                _ -> {
                  io.debug("Unknown Number as Trigger")
                  state
                }
              }
            }
            _ -> {
              io.debug("Unknown Trigger")
              state
            }
          }
        }
      }
    }

    _ -> {
      io.debug("Unknown message")
      state
    }
  }
}
