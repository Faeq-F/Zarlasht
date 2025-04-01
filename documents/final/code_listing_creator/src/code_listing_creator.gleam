import conversion.{convert, home}
import gleam/erlang/process
import gleam/io
import gleam/list
import lustre/element
import mist
import wisp.{type Request}
import wisp/wisp_mist

pub fn main() {
  io.println("Hello from code_listing_creator!")
  let assert Ok(_) =
    wisp_mist.handler(
      fn(req: Request) {
        use <- wisp.serve_static(req, under: "/static", from: "priv/static")

        case wisp.path_segments(req) {
          // Homepage
          [] ->
            home()
            |> element.to_string_builder
            |> wisp.html_response(200)
          ["source"] -> {
            use form <- wisp.require_form(req)
            let assert Ok(source) = form.values |> list.first()
            convert(source.1)
            |> wisp.html_response(200)
          }
          // All the empty responses
          ["internal-server-error"] -> wisp.internal_server_error()
          ["unprocessable-entity"] -> wisp.unprocessable_entity()
          ["method-not-allowed"] -> wisp.method_not_allowed([])
          ["entity-too-large"] -> wisp.entity_too_large()
          ["bad-request"] -> wisp.bad_request()
          _ -> wisp.not_found()
        }
      },
      "",
    )
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}
