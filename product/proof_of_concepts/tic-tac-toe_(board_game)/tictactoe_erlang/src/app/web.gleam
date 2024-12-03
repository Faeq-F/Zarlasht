import gleam/bytes_tree
import gleam/erlang/process.{type Subject}
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/int
import gleam/string
import logging.{Info}
import mist.{type Connection, type ResponseData, Bytes}
import radish.{type Message}

/// Contains the Subjects that publish and susbscribe to channels on Valkey
///
/// Since the subscriber is limited to certain commands after subscribing to a
/// channel, the publisher can be used for anything else that is required
///
pub type Context {
  Context(publisher: Subject(Message), subscriber: Subject(Message))
}

/// The middleware stack that the request handler uses.
///
/// Middleware wrap each other, so the request travels through the stack from
/// top to bottom until it reaches the request handler, at which point the
/// response travels back up through the stack.
///
pub fn middleware(
  req: Request(Connection),
  _ctx: Context,
  handle_request: fn(Request(Connection)) -> Response(ResponseData),
) -> Response(ResponseData) {
  // add server rescue
  use <- log_request(req)
  use <- default_responses
  handle_request(req)
}

pub fn default_responses(
  handle_request: fn() -> Response(ResponseData),
) -> Response(ResponseData) {
  let response = handle_request()
  case response.status {
    404 | 405 ->
      response
      |> response.set_body(Bytes(bytes_tree.from_string("<h1>Not Found</h1>")))
      |> response.set_header("content-type", "text/html; charset=utf-8")

    400 | 422 ->
      response
      |> response.set_body(
        Bytes(bytes_tree.from_string("<h1>Bad request</h1>")),
      )
      |> response.set_header("content-type", "text/html; charset=utf-8")

    413 ->
      response
      |> response.set_body(
        Bytes(bytes_tree.from_string("<h1>Request entity too large</h1>")),
      )
      |> response.set_header("content-type", "text/html; charset=utf-8")

    500 ->
      response
      |> response.set_body(
        Bytes(bytes_tree.from_string("<h1>Internal server error</h1>")),
      )
      |> response.set_header("content-type", "text/html; charset=utf-8")

    _ -> response
  }
}

fn log_request(
  req: Request(Connection),
  handler: fn() -> Response(ResponseData),
) -> Response(ResponseData) {
  let response = handler()
  let message =
    [
      int.to_string(response.status),
      " ",
      string.uppercase(http.method_to_string(req.method)),
      " ",
      req.path,
    ]
    |> string.concat

  logging.log(Info, message)
  response
}
