import glen/ws
import pages/game.{game_page, update_status}
import pages/set_name.{waiting}
import socket_state.{type Event, type State, State}
import state.{
  for_all_sockets, get_json_value, get_turn, get_winning_player, set_player_name,
}

pub fn on_set_name(
  text_message: String,
  conn: ws.WebsocketConn(Event),
  state: State,
) -> State {
  let name = get_json_value(text_message, "name")
  case set_player_name(state.game_code, conn, name) {
    0 -> {
      for_all_sockets(state.game_code, fn(socket, player_viewed, _name) {
        let _ = ws.send_text(socket, game_page())
        //update game grid
        let _ =
          ws.send_text(
            socket,
            game.game_grid(
              state.game_code,
              player_viewed,
              get_turn(state.game_code) == player_viewed,
            ),
          )
        //update player names
        for_all_sockets(state.game_code, fn(_socket, player, name) {
          let _ = ws.send_text(socket, game.player(player, name))
          Nil
        })
        //update status
        let _ =
          ws.send_text(
            socket,
            update_status(
              get_turn(state.game_code) == player_viewed,
              player_viewed,
              get_winning_player(state.game_code),
            ),
          )
        Nil
      })
      state
    }
    _ -> {
      let _ = ws.send_text(conn, waiting())
      state
    }
  }
}
