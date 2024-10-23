//// Utility functions from the JavaScript FFI

/// Helper function that returns the value for a key in some stringified JSON
///
@external(javascript, "./utils.ffi.mjs", "ffi_get_json_value")
pub fn get_json_value(json_string: String, key: String) -> String
