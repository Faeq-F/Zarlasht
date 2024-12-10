import app/actors/director
import app/router
import app/web.{Context}
import gleam/erlang/process
import glenvy/dotenv
import logging
import mist
import valkey.{radish_flush_db, valkey_client}

// TODO
// Need to check the entire program for load balancing dependencies - e.g., ETS data sharing

pub fn main() {
  logging.configure()
  logging.log(logging.Debug, "Some logs may be ASCII encoded")
  let director = director.start()
  //load .env vars
  let _ = dotenv.load()
  // configure server
  let ctx = Context(valkey_client(), valkey_client())
  let assert Ok(_) = radish_flush_db(ctx.publisher, 128)
  let assert Ok(_) =
    router.handle_request(_, ctx, director)
    |> mist.new
    |> mist.port(8000)
    // could randomize for recovery scenarios (in case new app takes over) & restarting for errors & see wisp recovery - 500 for handler?
    |> mist.start_https("chat.crt", "chat.key")

  // The web server runs in new Erlang process
  // so put this one to sleep while it works concurrently
  Ok(process.sleep_forever())
}
