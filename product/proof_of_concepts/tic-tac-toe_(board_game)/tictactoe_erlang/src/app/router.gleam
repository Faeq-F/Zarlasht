import app/pages
import app/pages/layout.{layout}
import app/sockets.{new_socket_process}
import app/web.{type Context}
import gleam/bytes_tree
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response, Response}
import gleam/list
import gleam/option.{None}
import gleam/result
import gleam/string
import lustre/element
import mist.{type Connection, type ResponseData, Bytes}

/// The HTTP request handler
///
pub fn handle_request(
  req: Request(Connection),
  ctx: Context,
) -> Response(ResponseData) {
  // Apply the middleware stack for this request/response.
  use _req <- web.middleware(req, ctx)

  case request.path_segments(req) {
    // Homepage
    [] -> {
      let doc_string =
        [pages.home()]
        |> layout
        |> element.to_document_string
      response.new(200)
      |> response.set_body(Bytes(bytes_tree.from_string(doc_string)))
      |> response.set_header("content-type", "text/html; charset=utf-8")
    }

    // Websockets
    ["init_socket"] -> new_socket_process(req)

    // Static files
    ["static", ..rest] -> serve_static(req, rest)

    // All the empty responses
    ["internal-server-error"] ->
      response.new(500) |> response.set_body(mist.Bytes(bytes_tree.new()))
    ["unprocessable-entity"] ->
      response.new(422) |> response.set_body(mist.Bytes(bytes_tree.new()))
    ["method-not-allowed"] ->
      response.new(405) |> response.set_body(mist.Bytes(bytes_tree.new()))
    ["entity-too-large"] ->
      response.new(413) |> response.set_body(mist.Bytes(bytes_tree.new()))
    ["bad-request"] ->
      response.new(400) |> response.set_body(mist.Bytes(bytes_tree.new()))
    _ -> response.new(404) |> response.set_body(mist.Bytes(bytes_tree.new()))
  }
}

fn serve_static(_req: Request(Connection), path: List(String)) {
  let file_path = string.join(["static", ..path], "/")
  // need validation
  mist.send_file(file_path, offset: 0, limit: None)
  |> result.map(fn(file) {
    response.new(200)
    |> response.prepend_header("content-type", get_content_type(file_path))
    |> response.set_body(file)
  })
  |> result.lazy_unwrap(fn() {
    response.new(404)
    |> response.set_body(mist.Bytes(bytes_tree.new()))
  })
}

fn get_content_type(file_path: String) {
  let extensions = string.split(file_path, ".")
  case list.last(extensions) {
    Ok("js") -> "text/javascript; charset=utf-8"
    Ok("css") -> "text/css; charset=utf-8"
    Ok("png") -> "image/png"
    _ -> "application/octet-stream"
  }
}
