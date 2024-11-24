//// All Websocket related functions for the app

import gleam/erlang/process
import gleam/http/request.{type Request, Request}
import gleam/io
import gleam/option.{Some}
import gleam/otp/actor
import logging.{Info}
import mist.{type Connection}

///See [here](https://hexdocs.pm/mist/mist.html#websocket)
///
pub fn new_socket_process(req: Request(Connection)) {
  mist.websocket(
    request: req,
    on_init: fn(_conn) { #(Nil, Some(process.new_selector())) },
    on_close: fn(_state) { io.println("A Websocket Disconnected") },
    handler: handle_ws_message,
  )
}

pub type MyMessage {
  Broadcast(String)
}

fn handle_ws_message(state, conn, message) {
  logging.log(Info, "Websocket message recieved:")
  io.debug(message)
  case message {
    mist.Text("ping") -> {
      let assert Ok(_) = mist.send_text_frame(conn, "pong")
      actor.continue(state)
    }
    mist.Text(_) | mist.Binary(_) -> {
      actor.continue(state)
    }
    mist.Custom(Broadcast(text)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, text)
      actor.continue(state)
    }
    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}
