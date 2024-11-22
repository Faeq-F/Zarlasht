import app/router
import app/web.{Context}
import gleam/erlang/process
import gleam/result.{try}
import glenvy/dotenv
import glenvy/env
import logging
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  logging.configure()
  let ctx = Context(static_directory())
  let assert Ok(_) =
    router.handle_request(_, ctx)
    |> mist.new
    |> mist.port(8000)
    // could randomize for recovery scenarios (in case new app takes over)
    |> mist.start_https("pong.crt", "pong.key")

  // The web server runs in new Erlang process
  // so put this one to sleep while it works concurrently
  Ok(process.sleep_forever())
}

fn static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("pong_erlang")
  priv_directory <> "/static"
}
