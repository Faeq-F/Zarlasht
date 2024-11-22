import app/pages
import app/pages/layout.{layout}
import app/web.{type Context}
import gleam/erlang/process
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response, Response}
import gleam/io
import gleam/option.{Some}
import gleam/otp/actor
import lustre/element
import mist.{type Connection, type ResponseData}

/// The HTTP request handler
///
fn handle_request(
  req: Request(Connection),
  ctx: Context,
) -> Response(ResponseData) {
  // Apply the middleware stack for this request/response.
  use _req <- web.middleware(req, ctx)
  case request.path_segments(req) {
    // Homepage
    [] -> {
      [pages.home()]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
    //Websockets
    ["init_socket"] -> {
      mist.websocket(
        request: req,
        on_init: fn(_conn) { #(Nil, Some(process.new_selector())) },
        on_close: fn(_state) { io.println("goodbye!") },
        handler: handle_ws_message,
      )
      response(200)
    }

    // All the empty responses
    ["internal-server-error"] -> response(500)
    ["unprocessable-entity"] -> response(422)
    ["method-not-allowed"] -> response(405)
    ["entity-too-large"] -> response(413)
    ["bad-request"] -> response(400)
    _ -> response(404)
  }
}

pub type MyMessage {
  Broadcast(String)
}

fn handle_ws_message(state, conn, message) {
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
