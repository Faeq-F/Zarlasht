import gleam/result
import glenvy/env
import radish
import radish/error
import radish/resp
import radish/utils.{execute, prepare}

pub fn valkey_client() {
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
