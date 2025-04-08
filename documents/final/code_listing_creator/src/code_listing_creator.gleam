/// The code_listing_creator program
///
/// Allows you to produce a pdf with syntax highlighted Gleam code,
/// which you can then use in your LaTeX documents with,
/// for e.g., `\includegraphics{code.pdf}`.
import conversion.{convert, home}
import gleam/erlang/process
import gleam/list
import lustre/element
import mist
import wisp.{type Request}
import wisp/wisp_mist

/// The entry-point of the program
///
/// Starts the web server on port 8000 and handles incoming requests.
///
pub fn main() {
  let assert Ok(_) =
    wisp_mist.handler(
      fn(req: Request) {
        use <- wisp.serve_static(req, under: "/static", from: "priv/static")

        case wisp.path_segments(req) {
          [] -> homepage()
          ["source"] -> conversion(req)
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

/// A response containing the highlighted code
///
fn conversion(req: Request) {
  use form <- wisp.require_form(req)
  let assert Ok(source) = form.values |> list.first()

  convert(source.1)
  |> wisp.html_response(200)
}

/// A response containing the homepage
///
fn homepage() {
  home()
  |> element.to_string_builder
  |> wisp.html_response(200)
}
