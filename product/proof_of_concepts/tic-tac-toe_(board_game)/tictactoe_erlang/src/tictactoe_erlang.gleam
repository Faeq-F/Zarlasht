import app/router
import app/web.{Context}
import gleam/erlang/process
import gleam/result
import glemo
import glenvy/dotenv
import glenvy/env
import logging
import mist
import radish
import radish/error
import radish/resp
import radish/utils.{execute, prepare}

// Need to check the entire program for load balancing dependencies

pub fn main() {
  glemo.init(["cache"])
  let _ = dotenv.load()
  logging.configure()
  let ctx = Context(valkey_client(), valkey_client())
  let assert Ok(_) = radish_flush_db(ctx.publisher, 128)
  let assert Ok(_) =
    router.handle_request(_, ctx)
    |> mist.new
    |> mist.port(8000)
    // could randomize for recovery scenarios (in case new app takes over)
    |> mist.start_https("tictactoe.crt", "tictactoe.key")

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

//-------------------------------------------------------------------
// Meant to be a part of the radish library

fn flush_db() {
  ["FLUSHDB"]
  |> prepare
}

/// see [here](https://redis.io/commands/flushdb)!
///
/// to flush the database asynchronously use `flush_db_async`.
pub fn radish_flush_db(client, timeout: Int) {
  //command.flush_db()
  flush_db()
  |> execute(client, _, timeout)
  |> result.map(fn(value) {
    case value {
      [resp.SimpleString("OK")] -> Ok("OK")
      _ -> Error(error.RESPError)
    }
  })
  |> result.flatten
}
// fn flush_db_async() {
//   ["FLUSHDB", "ASYNC"]
//   |> prepare
// }
