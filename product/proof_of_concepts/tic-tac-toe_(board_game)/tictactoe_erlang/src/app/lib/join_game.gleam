import app/actor_types.{
  type PlayerSocket, type WebsocketActorState, O, WebsocketActorState,
}
import app/pages/set_name.{set_name_page}
import app/pages/to_join_game.{join_game_page, wrong_code}
import app/web.{type Context}
import carpenter/table
import gleam/dict
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/json.{int, object, string}
import gleam/otp/actor
import gleam/yielder.{each, from_list}
import juno
import mist
import radish
import utils.{valkey_client}

//----------------------------------------------------------------
// Before game code input

pub fn on_to_join_game(player: PlayerSocket) -> WebsocketActorState {
  let assert Ok(_) = mist.send_text_frame(player.socket, join_game_page())
  player.state
}

//----------------------------------------------------------------
// After game code input

pub fn on_join_game(
  message: String,
  player: PlayerSocket,
) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(game_code)) = message_dict |> dict.get("gameCode")
  case int.parse(game_code) {
    Ok(code) -> {
      let assert Ok(game_sockets) = table.ref("game_sockets")
      case game_sockets |> table.lookup(code) {
        [] -> {
          let assert Ok(_) = mist.send_text_frame(player.socket, wrong_code())
          player.state
        }
        val -> {
          let assert [#(code, current_sockets)] = val
          let new_sockets_list = [player, ..current_sockets]
          game_sockets |> table.insert([#(code, new_sockets_list)])
          //
          //send current user to the set_name page
          // let assert Ok(_) =
          //   mist.send_text_frame(player.socket, set_name_page())
          //
          //send everyone else to the set_name page
          // from_list(current_sockets)
          // |> each(fn(other_player: PlayerSocket) {
          //   actor.send(
          //     other_player.state.subject,
          //     ActorMessage(set_name_page()),
          //   )
          // })
          //
          WebsocketActorState(..player.state, player: O)
        }
      }
    }
    _ -> {
      let assert Ok(_) = mist.send_text_frame(player.socket, wrong_code())
      player.state
    }
  }
}
