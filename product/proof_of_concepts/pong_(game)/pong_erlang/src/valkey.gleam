//// Database related functions

import gleam/erlang/process
import gleam/result
import glenvy/env
import radish.{type Next}
import radish/error
import radish/resp
import radish/utils.{execute, prepare}

/// Subscribes to channels using a new valkey client
///
/// Please see [this](https://hexdocs.pm/radish/radish.html#subscribe)!
///
pub fn valkey_subscribe(
  channels: List(String),
  on_subscribe: fn(String, Int) -> Nil,
  on_message: fn(String, String) -> Next,
) {
  process.start(
    fn() {
      radish.subscribe(valkey_client(), channels, on_subscribe, on_message, 128)
    },
    True,
  )
}

// can pub a message on game creation so all servers are aware of the game (also applys for actions in it)

/// Creates a new client process for the database using credentials from the .env file
///
pub fn valkey_client() {
  let assert Ok(valkey_uri) = env.get_string("SERVICE_URI")
  let assert Ok(valkey_port) = env.get_int("SERVICE_PORT")
  let assert Ok(client) =
    radish.start(valkey_uri, valkey_port, [radish.Timeout(128)])
  client
}

//-------------------------------------------------------------------
// Todo
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
