import gleam/result
import glenvy/env
import radish
import radish/error
import radish/resp
import radish/utils.{execute, prepare}

// valkeySub.on("message", (channel, message) => {
//   console.log(`Message ${message} was sent to chat \"${channel}\"`);
//   const chat_sockets = sockets.get(channel);
//   if (chat_sockets != undefined) {
//     chat_sockets
//       .filter((conn) =>
//         conn.state.username != ffi_get_json_value(message, "username")
//       )
//       .forEach((conn) => {
//         conn.socket.send(ffi_get_json_value(message, "html"));
//       });
//   }
// });
// process.start(
//     fn() {
//       radish.subscribe(
//         ctx.subscriber,
//         ["channel"],
//         on_subscribe,
//         on_radish_message,
//         128,
//       )
//     },
//     True,
//   )

//
// fn on_subscribe(channel: String, subscribers: Int) {
//   io.debug(
//     "'"
//     <> channel
//     <> "' has been subscribed to. There are now "
//     <> int.to_string(subscribers)
//     <> " subscribers to this channel.",
//   )
//   Nil
// }

//
// fn on_radish_message(channel: String, message: String) {
//   io.debug(
//     "The channel '" <> channel <> "' recieved the message '" <> message <> "'",
//   )

//   radish.Continue
// }

//let assert Ok(subscribers) = radish.publish(ctx.publisher, "channel", "message", 128)
//logging.log(Info, int.to_string(subscribers)<>" subscribers listened.")

// can pub a message on game creation so all servers are aware of the game (also applys for actions in it)

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
