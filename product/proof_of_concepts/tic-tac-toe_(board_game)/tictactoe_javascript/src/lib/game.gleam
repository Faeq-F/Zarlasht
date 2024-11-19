import glen/ws
import lustre/element.{to_string}
import pages/game.{message, send_message_form, update_status}
import socket_state.{type Event, type State, State}
import state.{
  for_all_sockets, get_json_value, get_turn, get_winning_player, reset_game,
  update_state,
}

pub fn on_box_click(box: Int, state: State) -> State {
  update_state(state.game_code, box)
  let winner = get_winning_player(state.game_code)
  for_all_sockets(state.game_code, fn(socket, player, _name) {
    //update status text
    let _ =
      ws.send_text(
        socket,
        update_status(get_turn(state.game_code) == player, player, winner),
      )
    // send updated grid
    let _ =
      ws.send_text(
        socket,
        game.game_grid(state.game_code, player, case winner == "Neither" {
          True -> get_turn(state.game_code) == player
          _ -> False
          // if someone has won, the grid should no longer have clickable boxes
        }),
      )
    Nil
  })
  state
}

pub fn on_send_message(
  text_message: String,
  conn: ws.WebsocketConn(Event),
  state: State,
) -> State {
  let message_text = get_json_value(text_message, "message")
  case message_text {
    "" -> {
      state
    }
    _ -> {
      for_all_sockets(state.game_code, fn(socket, player, _name) {
        case state.player == player {
          True -> {
            let _ = ws.send_text(socket, message(message_text, True))
            Nil
          }
          _ -> {
            let _ = ws.send_text(socket, message(message_text, False))
            Nil
          }
        }
      })
      let _ = ws.send_text(conn, send_message_form() |> to_string)
      state
    }
  }
}

pub fn on_replay_game(state: State) -> State {
  reset_game(state.game_code)
  for_all_sockets(state.game_code, fn(socket, player_viewed, _name) {
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
