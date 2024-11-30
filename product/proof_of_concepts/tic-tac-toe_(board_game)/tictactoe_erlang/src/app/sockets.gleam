//// All Websocket related functions for the app

import app/actor_types.{
  type CustomWebsocketMessage, type DirectorActorMessage, type PlayerSocket,
  type WebsocketActorState, Disconnect, EnqueueParticipant, JoinGame, Neither,
  PlayerSocket, SendToAll, SendToClient, WebsocketActorState,
}
import app/lib/create_game.{on_create_game}
import app/lib/join_game.{on_join_game, on_to_join_game}
import app/pages/set_name.{set_name_page}
import app/web.{type Context}
import carpenter/table
import gleam/dict
import gleam/dynamic
import gleam/erlang/process.{
  type Selector, type Subject, new_subject, select_forever, selecting_anything,
}
import gleam/function.{identity}
import gleam/http/request.{type Request, Request}
import gleam/int
import gleam/io
import gleam/option.{None, Some}
import gleam/otp/actor
import gleam/yielder.{each, from_list}
import juno
import logging.{Alert, Info}
import mist.{type Connection, Custom}
import radish

///See [here](https://hexdocs.pm/mist/mist.html#websocket)
///
pub fn new_socket_process(
  req: Request(Connection),
  ctx: Context,
  director: Subject(DirectorActorMessage),
) {
  mist.websocket(
    request: req,
    on_init: fn(_conn) {
      let sockets_subject = new_subject()
      // Create a new subject for the current websocket process that other actors will be able to send messages to
      let ws_subject = process.new_subject()
      let new_selector =
        process.new_selector()
        |> process.selecting(ws_subject, function.identity)
      // Set state for the connection with empty defaults
      #(
        WebsocketActorState(
          name: "",
          player: Neither,
          ws_subject: ws_subject,
          game_subject: None,
          director_subject: director,
        ),
        Some(new_selector),
      )
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
          on_join_game(message, PlayerSocket(conn, state))
          |> actor.continue

        _ -> {
          logging.log(Alert, "Unknown Trigger")
          actor.continue(state)
        }
      }
    }

    mist.Custom(JoinGame(game_subject)) -> {
      let new_state =
        WebsocketActorState(..state, game_subject: Some(game_subject))
      let assert Ok(_) = mist.send_text_frame(conn, set_name_page())

      //stringifies message and send as text
      // send_client_json(
      //   connection,
      //   socket_message.custom_body_to_json(
      //     "joined",
      //     json.array(participants, of: json.string),
      // ),
      // )

      new_state |> actor.continue
    }

    mist.Custom(Disconnect) -> {
      // ask queue actor for a match
      // use name <- option.then(state.name)

      // process.send(
      //   state.queue_subject,
      //   EnqueueParticipant(name, state.ws_subject),
      // )
      // Some(send_client_json(
      //   connection,
      //   socket_message.new("enqueued", "User successfully enqueued")
      //     |> socket_message.to_json,
      // ))
      state |> actor.continue
    }

    mist.Custom(SendToClient(text)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, text)
      actor.continue(state)
    }

    mist.Binary(_) -> {
      actor.continue(state)
    }

    // mist.Custom(Broadcast(text)) -> {
    //   let assert Ok(_) = mist.send_text_frame(conn, text)
    //   actor.continue(state)
    // }
    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}

fn handle_message_from_subject(message: dynamic.Dynamic) {
  let assert Ok(message) = dynamic.string(message)
  io.debug("got" <> message)
  message
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
fn on_subscribe(channel: String, subscribers: Int) {
  io.debug(
    "'"
    <> channel
    <> "' has been subscribed to. There are now "
    <> int.to_string(subscribers)
    <> " subscribers to this channel.",
  )
  Nil
}

//
// fn on_radish_message(channel: String, message: String) {
//   io.debug(
//     "The channel '" <> channel <> "' recieved the message '" <> message <> "'",
//   )

//   radish.Continue
// }

// process.start(
//         fn() {
//           radish.subscribe(
//             ctx.subscriber,
//             ["channel"],
//             on_subscribe,
//             on_radish_message,
//             128,
//           )
//         },
//         True,
//       )

//let assert Ok(subscribers) = radish.publish(ctx.publisher, "channel", "message", 128)
//logging.log(Info, int.to_string(subscribers)<>" subscribers listened.")

// can pub a message on game creation so all servers are aware of the game (also applys for actions in it)

fn handler(sockets_selector) {
  io.debug("Running Selector Handler")
  process.start(
    fn() {
      select_forever(sockets_selector) |> send_subject_message
      handler(sockets_selector)
    },
    True,
  )
}

fn send_subject_message(message: String) {
  io.debug("yep" <> message)
}
