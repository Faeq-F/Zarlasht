import glen/ws
import socket_state.{type Event}

@external(javascript, "./state.ffi.mjs", "ffi_add_game")
pub fn add_game(game_code: Int, socket: ws.WebsocketConn(Event)) -> Int

//returns 1 if other sockets still need to disconnect
@external(javascript, "./state.ffi.mjs", "ffi_remove_socket")
pub fn remove_socket(game_code: Int, player: String) -> Int

@external(javascript, "./state.ffi.mjs", "ffi_for_all_sockets")
pub fn for_all_sockets(
  game_code: Int,
  action: fn(ws.WebsocketConn(Event), String, String) -> Nil,
) -> Int

@external(javascript, "./state.ffi.mjs", "ffi_get_json_value")
pub fn get_json_value(json_string: String, key: String) -> String
