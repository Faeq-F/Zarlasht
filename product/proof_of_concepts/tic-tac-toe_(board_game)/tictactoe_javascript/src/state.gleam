//// State related functions from the JavaScript FFI.
////
//// If returning an integer, a 0 is the function has succeeded, failing otherwise

import glen/ws
import socket_state.{type Event}

/// Adds a game to the server state, along with the creator of the game
///
@external(javascript, "./state.ffi.mjs", "ffi_add_game")
pub fn add_game(game_code: Int, socket: ws.WebsocketConn(Event)) -> Int

/// Adds a player to a game
///
@external(javascript, "./state.ffi.mjs", "ffi_add_socket")
pub fn add_socket(socket: ws.WebsocketConn(Event), game_code: Int) -> Int

/// Removes a player from a game
///
/// returns 1 if other sockets still need to disconnect
///
@external(javascript, "./state.ffi.mjs", "ffi_remove_socket")
pub fn remove_socket(game_code: Int, player: String) -> Int

/// Resets the state for a game
///
@external(javascript, "./state.ffi.mjs", "ffi_reset_game")
pub fn reset_game(game_code: Int) -> Nil

/// Utility function that allows you to run a task for every user in a game
///
@external(javascript, "./state.ffi.mjs", "ffi_for_all_sockets")
pub fn for_all_sockets(
  game_code: Int,
  action: fn(ws.WebsocketConn(Event), String, String) -> Nil,
) -> Int

/// Gets the player marking from a game's state
///
@external(javascript, "./state.ffi.mjs", "ffi_get_player_from_game_state")
pub fn get_player_from_game_state(game_code: Int, index: Int) -> String

/// Helps decode JSON
///
/// provides the value for a key in a JSON object
///
@external(javascript, "./state.ffi.mjs", "ffi_get_json_value")
pub fn get_json_value(json_string: String, key: String) -> String

/// Get whether it is the X or O player's turn in a game
///
@external(javascript, "./state.ffi.mjs", "ffi_get_turn")
pub fn get_turn(game_code: Int) -> String

/// Gets the winning player for a game
///
/// Returns "X", "O", or "Draw" if a game has ended
///
/// Returns "Neither" if a game has not ended
///
@external(javascript, "./state.ffi.mjs", "ffi_get_winning_player")
pub fn get_winning_player(game_code: Int) -> String

/// Set a player's name
///
@external(javascript, "./state.ffi.mjs", "ffi_set_player_name")
pub fn set_player_name(
  game_code: Int,
  socket: ws.WebsocketConn(Event),
  name: String,
) -> Int

/// Called when a player has clicked on a box, updating the game state
///
/// (using the turn saved in the game state)
///
@external(javascript, "./state.ffi.mjs", "ffi_update_state")
pub fn update_state(game_code: Int, index: Int) -> Int
