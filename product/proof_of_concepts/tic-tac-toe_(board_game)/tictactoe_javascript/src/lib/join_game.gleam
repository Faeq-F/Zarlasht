import gleam/int
import glen/ws
import pages/to_join_game.{join_game_page, wrong_code}
import socket_state.{type Event, type State, State}
import state.{get_json_value}

//----------------------------------------------------------------
// Before game code input

pub fn on_to_join_game(conn: ws.WebsocketConn(Event)) -> State {
  let _ = ws.send_text(conn, join_game_page())
  State(-1, "Neither")
}

//----------------------------------------------------------------
// After game code input

pub fn on_join_game(
  text_message: String,
  conn: ws.WebsocketConn(Event),
) -> State {
  case int.parse(get_json_value(text_message, "gameCode")) {
    Ok(code) -> {
      let _ = ws.send_text(conn, wrong_code())
      State(-1, "Neither")
    }
    _ -> {
      let _ = ws.send_text(conn, wrong_code())
      State(-1, "Neither")
    }
  }
}
