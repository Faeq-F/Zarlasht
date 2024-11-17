import glen/ws
import socket_state.{type Event}

@external(javascript, "./state.ffi.mjs", "ffi_add_game")
pub fn add_game(game_code: Int, socket: ws.WebsocketConn(Event)) -> Int

@external(javascript, "./state.ffi.mjs", "ffi_add_socket")
pub fn add_socket(socket: ws.WebsocketConn(Event), game_code: Int) -> Int

//returns 1 if other sockets still need to disconnect
@external(javascript, "./state.ffi.mjs", "ffi_remove_socket")
pub fn remove_socket(game_code: Int, player: String) -> Int

@external(javascript, "./state.ffi.mjs", "ffi_for_all_sockets")
pub fn for_all_sockets(
  game_code: Int,
  action: fn(ws.WebsocketConn(Event), String, String) -> Nil,
) -> Int

@external(javascript, "./state.ffi.mjs", "ffi_get_player_from_game_state")
pub fn get_player_from_game_state(game_code: Int, index: Int) -> String

@external(javascript, "./state.ffi.mjs", "ffi_get_json_value")
pub fn get_json_value(json_string: String, key: String) -> String

@external(javascript, "./state.ffi.mjs", "ffi_get_turn")
pub fn get_turn(game_code: Int) -> String

@external(javascript, "./state.ffi.mjs", "ffi_get_winning_player")
pub fn get_winning_player(game_code: Int) -> String

@external(javascript, "./state.ffi.mjs", "ffi_set_player_name")
pub fn set_player_name(
  game_code: Int,
  socket: ws.WebsocketConn(Event),
  name: String,
) -> Int
