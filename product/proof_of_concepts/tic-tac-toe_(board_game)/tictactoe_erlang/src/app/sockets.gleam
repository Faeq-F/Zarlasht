//// All Websocket related functions for the app

import app/lib/create_game.{on_create_game}
import app/lib/join_game.{on_join_game, on_to_join_game}
import app/socket_types.{
  type ActorState, ActorState, Broadcast, Neither, PlayerSocket,
}
import gleam/dict
import gleam/erlang/process
import gleam/http/request.{type Request, Request}
import gleam/io
import gleam/option.{Some}
import gleam/otp/actor
import juno
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
      let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
      let assert Ok(juno.Object(headers_dict)) =
        message_dict |> dict.get("HEADERS")
      let assert Ok(juno.String(trigger)) =
        headers_dict |> dict.get("HX-Trigger")

      case trigger {
        "create" -> on_create_game(PlayerSocket(conn, state)) |> actor.continue
        "join" -> on_to_join_game(PlayerSocket(conn, state)) |> actor.continue
        "join-game-form" ->
          on_join_game(message, PlayerSocket(conn, state)) |> actor.continue

        _ -> {
          logging.log(Alert, "Unknown Trigger")
          actor.continue(state)
        }
      }
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
