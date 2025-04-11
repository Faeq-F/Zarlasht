//// The site itself

import app/actors/director
import app/router
import app/web.{Context}
import carpenter/table
import gleam/erlang/process
import gleam/otp/supervisor
import glenvy/dotenv
import logging
import mist
import valkey.{radish_flush_db, valkey_client}

// TODO
// Need to check the entire program for load balancing dependencies - e.g., ETS data sharing - save to db for long-term & sync using pub/sub

/// The entry-point for the program
///
pub fn main() {
  //setup main supervisor
  let main_subject = process.new_subject()
  let main_child = supervisor.worker(director.start(_, main_subject))
  let assert Ok(_supervisor_subject) =
    supervisor.start(supervisor.add(_, main_child))
  let assert Ok(director_subject) = process.receive(main_subject, 1000)

  // Set up and configure a helper ETS table
  // for games that have been created but have not been started
  let _ =
    table.build("waiting_games")
    |> table.privacy(table.Public)
    |> table.write_concurrency(table.AutoWriteConcurrency)
    |> table.read_concurrency(True)
    |> table.decentralized_counters(True)
    |> table.compression(False)
    |> table.set

  //load .env vars
  let _ = dotenv.load()
  // configure server
  logging.configure()
  let ctx = Context(valkey_client(), valkey_client())
  let assert Ok(_) = radish_flush_db(ctx.publisher, 128)
  let assert Ok(_server_supervisor) =
    router.handle_request(_, ctx, director_subject)
    |> mist.new
    |> mist.port(8000)
    // Todo
    // could randomize for recovery scenarios (in case new app takes over) & restarting for errors & see wisp recovery - 500 for handler?
    |> mist.start_https("zarlasht.crt", "zarlasht.key")

  // The web server runs in new Erlang process
  // so put this one to sleep while it works concurrently
  Ok(process.sleep_forever())
}
