import app/router
import app/web.{Context}
import gleam/erlang/process
import glenvy/dotenv
import glenvy/env
import logging
import mist
import radish

pub fn main() {
  let _ = dotenv.load()
  logging.configure()
  let ctx = Context(valkey_client(), valkey_client())
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

fn valkey_client() {
  let assert Ok(valkey_uri) = env.get_string("SERVICE_URI")
  let assert Ok(valkey_port) = env.get_int("SERVICE_PORT")
  let assert Ok(client) =
    radish.start(valkey_uri, valkey_port, [radish.Timeout(128)])
  client
}
