//// The site itself

import app/actors/director
import app/router
import app/web.{Context}
import carpenter/table
import gleam/erlang/process
import glenvy/dotenv
import logging
import mist
import valkey.{radish_flush_db, valkey_client}

// TODO
// Need to check the entire program for load balancing dependencies - e.g., ETS data sharing

/// The entry-point for the program
///
pub fn main() {
  let director = director.start()
  // Set up and configure a helper ETS table
  // for holding games that have been created but need a second player
  // let _ =
  //   table.build("games")
  //   |> table.privacy(table.Public)
  //   |> table.write_concurrency(table.AutoWriteConcurrency)
  //   |> table.read_concurrency(True)
  //   |> table.decentralized_counters(True)
  //   |> table.compression(False)
  //   |> table.set
  //load .env vars
  let _ = dotenv.load()
  // configure server
  logging.configure()
  let ctx = Context(valkey_client(), valkey_client())
  let assert Ok(_) = radish_flush_db(ctx.publisher, 128)
  let assert Ok(_) =
    router.handle_request(_, ctx, director)
    |> mist.new
    |> mist.port(8000)
    // could randomize for recovery scenarios (in case new app takes over) & restarting for errors & see wisp recovery - 500 for handler?
    |> mist.start_https("pong.crt", "pong.key")

  // The web server runs in new Erlang process
  // so put this one to sleep while it works concurrently
  Ok(process.sleep_forever())
}
