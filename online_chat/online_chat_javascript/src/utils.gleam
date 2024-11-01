//// Utility functions from the JavaScript FFI

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}

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
