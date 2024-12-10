//// All Websocket related functions for the app

import app/actors/actor_types.{
  type DirectorActorMessage, type UserSocket, type WebsocketActorState,
  RemoveParticipant, SendToClient, UserSocket, WebsocketActorState,
}
import app/lib/chat_action.{on_send_message}
import app/lib/create_chat.{on_create_chat}
import app/lib/join_chat.{on_join_chat, on_to_join_chat}
import app/lib/name_set.{set_name}
import app/web.{type Context}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/http/request.{type Request, Request}
import gleam/io
import gleam/option.{Some}
import gleam/otp/actor
import juno
import logging.{Alert, Info}
import mist.{type Connection, Custom}

///See [here](https://hexdocs.pm/mist/mist.html#websocket)
///
pub fn new(
  req: Request(Connection),
  director: Subject(DirectorActorMessage),
  ctx: Context,
) {
  mist.websocket(
    request: req,
    on_init: fn(_conn) {
      // Create a new subject for the current websocket process
      // that other actors will be able to send messages to
      let ws_subject = process.new_subject()
      let new_selector =
        process.new_selector()
        |> process.selecting(ws_subject, function.identity)
      logging.log(Info, "A Websocket Connected")
      // Set state for the connection with empty defaults
      #(
        WebsocketActorState(
          name: "",
          chat_code: 0,
          ws_subject: ws_subject,
          director_subject: director,
          context: ctx,
        ),
        Some(new_selector),
      )
    },
    on_close: fn(state) {
      logging.log(Info, "A Websocket Disconnected")
      process.send(
        state.director_subject,
        RemoveParticipant(state.chat_code, state.name),
      )
      Nil
    },
    handler: handle_ws_message,
  )
}

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
        "create" -> on_create_chat(UserSocket(conn, state)) |> actor.continue
        "join" -> on_to_join_chat(UserSocket(conn, state)) |> actor.continue
        "join-chat-form" ->
          on_join_chat(message, UserSocket(conn, state))
          |> actor.continue
        "set-name-form" ->
          set_name(message, UserSocket(conn, state)) |> actor.continue
        "send_message_form" ->
          on_send_message(message, UserSocket(conn, state)) |> actor.continue

        _ -> {
          logging.log(Alert, "Unknown Trigger")
          actor.continue(state)
        }
      }
    }

    mist.Custom(SendToClient(text)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, text)
      actor.continue(state)
    }

    mist.Binary(binary) -> {
      logging.log(logging.Notice, "Discarding unexpected binary; received ~")
      io.debug(binary)
      actor.continue(state)
    }

    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}
