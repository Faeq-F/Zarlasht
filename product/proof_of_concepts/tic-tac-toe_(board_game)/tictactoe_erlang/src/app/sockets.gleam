//// All Websocket related functions for the app

import app/lib/create_game.{on_create_game}
import app/socket_types.{
  type ActorState, type HEADERS, ActorState, Broadcast, HEADERS, MessageHTMX,
  Neither, PlayerSocket,
}
import gleam/dynamic.{field}
import gleam/erlang/process
import gleam/http/request.{type Request, Request}
import gleam/io
import gleam/json
import gleam/option.{Some}
import gleam/otp/actor
import logging.{Alert, Info}
import mist.{type Connection}

///See [here](https://hexdocs.pm/mist/mist.html#websocket)
///
pub fn new_socket_process(req: Request(Connection)) {
  mist.websocket(
    request: req,
    on_init: fn(_conn) {
      #(ActorState(Neither, ""), Some(process.new_selector()))
    },
    on_close: fn(_state) { io.println("A Websocket Disconnected") },
    handler: handle_ws_message,
  )
}

// actor state tuple of player & name

// player markings in boxes - left to right, top to bottom
// to_string(object([
//  #("state", [string("Neither"), string("Neither"), string("Neither"), string("Neither"), string("Neither"), string("Neither"), string("Neither"), string("Neither"), string("Neither")]),
//  #("turn", string("X")),
//]))

fn handle_ws_message(state, conn, message) {
  logging.log(Info, "Websocket message recieved ~")
  io.debug(message)
  case message {
    mist.Text("ping") -> {
      let assert Ok(_) = mist.send_text_frame(conn, "pong")
      actor.continue(state)
    }
    mist.Text(message) -> {
      case headers_from_htmx_message(message).hx_trigger {
        "create" -> {
          on_create_game(PlayerSocket(conn, state))
        }
        _ -> logging.log(Alert, "Unknown Trigger")
      }
      actor.continue(state)
    }

    mist.Binary(_) -> {
      actor.continue(state)
    }

    mist.Custom(Broadcast(text)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, text)
      actor.continue(state)
    }
    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}

// "create" -> {
//           on_create_game(conn)
//         }

// valkeySub.on("message", (channel, message) => {
//   console.log(`Message ${message} was sent to chat \"${channel}\"`);
//   const chat_sockets = sockets.get(channel);
//   if (chat_sockets != undefined) {
//     chat_sockets
//       .filter((conn) =>
//         conn.state.username != ffi_get_json_value(message, "username")
//       )
//       .forEach((conn) => {
//         conn.socket.send(ffi_get_json_value(message, "html"));
//       });
//   }
// });
// process.start(
//     fn() {
//       radish.subscribe(
//         ctx.subscriber,
//         ["channel"],
//         on_subscribe,
//         on_radish_message,
//         128,
//       )
//     },
//     True,
//   )
//
// fn on_subscribe(channel: String, subscribers: Int) {
//   io.debug("'"<>channel<> "' has been subscribed to. There are now "<>int.to_string(subscribers)<>" subscribers to this channel.")
//   Nil
// }
//
// fn on_radish_message(channel: String, message: String) {
//   io.debug("The channel '" <> channel <> "' recieved the message '" <> message <> "'")
//   radish.Continue
// }
//let assert Ok(subscribers) = radish.publish(ctx.publisher, "channel", "message", 128)
//logging.log(Info, int.to_string(subscribers)<>" subscribers listened.")

// can pub a message on game creation so all servers are aware of the game (also applys for actions in it)

fn headers_from_htmx_message(message_json: String) -> HEADERS {
  let message_decoder =
    dynamic.decode1(MessageHTMX, field("HEADERS", of: dynamic.string))
  let assert Ok(headers_string) =
    json.decode(from: message_json, using: message_decoder)
  let headers_decoder =
    dynamic.decode5(
      HEADERS,
      field("HX-Request", of: dynamic.bool),
      field("HX-Trigger", of: dynamic.string),
      field("HX-Trigger-Name", of: dynamic.optional(dynamic.string)),
      field("HX-Target", of: dynamic.string),
      field("HX-Current-URL", of: dynamic.string),
    )
  let assert Ok(headers) =
    json.decode(from: headers_string.headers, using: headers_decoder)
  headers
}
