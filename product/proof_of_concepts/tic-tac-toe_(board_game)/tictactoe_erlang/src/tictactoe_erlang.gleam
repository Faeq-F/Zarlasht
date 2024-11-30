import app/helper_actors/director_actor
import app/router
import app/web.{Context}
import carpenter/table
import gleam/erlang/process
import gleam/result
import glenvy/dotenv
import glenvy/env
import logging
import mist
import radish
import radish/error
import radish/resp
import utils.{radish_flush_db, valkey_client}

// Need to check the entire program for load balancing dependencies

// Need to delete game when socket disconnects

pub fn main() {
  let director = director_actor.start()
  // Set up and configure an ETS table for holding websockets
  let _ =
    table.build("game_sockets")
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
  let assert Ok(_) =
    router.handle_request(_, ctx, director)
    |> mist.new
    |> mist.port(8000)
    // could randomize for recovery scenarios (in case new app takes over)
    |> mist.start_https("tictactoe.crt", "tictactoe.key")

  // The web server runs in new Erlang process
  // so put this one to sleep while it works concurrently
  Ok(process.sleep_forever())
}
