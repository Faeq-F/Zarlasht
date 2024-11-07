//// Utility functions from the JavaScript FFI

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import glen/ws
import socket_state.{type Event}

/// Helper function that returns the value for a key in some stringified JSON
///
@external(javascript, "./utils.ffi.mjs", "ffi_get_json_value")
pub fn get_json_value(json_string: String, key: String) -> String

/// Saves a value in the database
///
@external(javascript, "./utils.ffi.mjs", "ffi_db_set")
pub fn db_set(key: String, value: Dynamic) -> Nil

/// Gets a value in the database
///
/// The getter always returns strings, even if a different type was set for that key
///
@external(javascript, "./utils.ffi.mjs", "ffi_db_get")
pub fn db_get(key: String) -> Promise(String)

/// Publish a message to a channel in Valkey
///
/// The channel should be the chat_code
///
@external(javascript, "./utils.ffi.mjs", "ffi_valkey_publish")
pub fn valkey_publish(channel: String, meessage: String) -> Nil

/// Subscribe to a channel in Valkey
///
/// The channel should be the chat_code
///
/// If the channel was already subscribed to, the subscription is skipped. The socket is added to the server's buffer regardless of this.
///
@external(javascript, "./utils.ffi.mjs", "ffi_valkey_subscribe")
pub fn valkey_subscribe(channel: String, socket: ws.WebsocketConn(Event)) -> Nil

/// Checks if the chat already exists
///
@external(javascript, "./utils.ffi.mjs", "ffi_chat_exists")
pub fn chat_exists(chat_code: Int) -> Bool
