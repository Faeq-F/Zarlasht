import chat.{chat}
import created_game.{created_game}
import game.{game}
import gleam/erlang/process
import home.{home}
import join_game.{join_game}
import layout.{layout}
import lustre/element
import map.{map}
import mist
import roll_die.{roll_die}
import set_name.{set_name}
import wisp.{type Request}
import wisp/wisp_mist

pub fn main() {
  let assert Ok(_) =
    wisp_mist.handler(
      fn(req: Request) {
        use <- wisp.serve_static(req, under: "/static", from: "priv/static")

        case wisp.path_segments(req) {
          // Homepage
          [] | ["home"] -> home() |> respond()
          ["created_game"] -> created_game() |> respond()
          ["join_game"] -> join_game() |> respond()
          ["set_name"] -> set_name() |> respond()
          ["game"] -> game() |> respond()
          ["roll_die"] -> roll_die() |> respond()
          ["chat"] -> chat() |> respond()
          ["map"] -> map() |> respond()

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

fn respond(page) {
  [page]
  |> layout()
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}
