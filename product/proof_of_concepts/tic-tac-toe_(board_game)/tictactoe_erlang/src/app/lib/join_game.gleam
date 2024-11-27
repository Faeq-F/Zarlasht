import app/pages/set_name.{set_name_page}
import app/pages/to_join_game.{join_game_page, wrong_code}
import app/socket_types.{
  type ActorState, type PlayerSocket, ActorState, Neither, O,
}
import carpenter/table
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/yielder.{each, from_list}
import juno
import mist

//----------------------------------------------------------------
// Before game code input

pub fn on_to_join_game(player: PlayerSocket) -> ActorState {
  let assert Ok(_) = mist.send_text_frame(player.socket, join_game_page())
  ActorState(Neither, "")
}

//----------------------------------------------------------------
// After game code input

pub fn on_join_game(message: String, player: PlayerSocket) -> ActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(game_code)) = message_dict |> dict.get("gameCode")
  case int.parse(game_code) {
    Ok(code) -> {
      let assert Ok(game_sockets) = table.ref("game_sockets")
      case game_sockets |> table.lookup(code) {
        [] -> {
          let assert Ok(_) = mist.send_text_frame(player.socket, wrong_code())
          ActorState(Neither, "")
        }
        _ -> {
          let new_sockets_list = [
            player,
            ..{ list.first(game_sockets |> table.lookup(code)) }
          ]
          game_sockets
          |> dict.insert(code, new_sockets_list)
          |> glemo.memo("cache", fn(dict) { dict })
          //send everyone to the set_name page
          from_list(new_sockets_list)
          |> each(fn(player: PlayerSocket) {
            let assert Ok(_) =
              mist.send_text_frame(player.socket, set_name_page())
          })
          ActorState(O, "")
        }
      }
    }
    _ -> {
      let assert Ok(_) = mist.send_text_frame(player.socket, wrong_code())
      ActorState(Neither, "")
    }
  }
}
