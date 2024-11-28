import app/pages/set_name.{set_name_page}
import app/pages/to_join_game.{join_game_page, wrong_code}
import app/socket_types.{
  type ActorState, type PlayerSocket, ActorState, Neither, O,
}
import app/web.{type Context}
import carpenter/table
import gleam/dict
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/otp/actor
import gleam/yielder.{each, from_list}
import juno
import mist
import radish
import utils.{valkey_client}

//----------------------------------------------------------------
// Before game code input

pub fn on_to_join_game(player: PlayerSocket) -> ActorState {
  let assert Ok(_) = mist.send_text_frame(player.socket, join_game_page())
  ActorState(Neither, "", player.state.subject)
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
          ActorState(Neither, "", player.state.subject)
        }
        val -> {
          let assert [#(code, current_sockets)] = val
          let new_sockets_list = [player, ..current_sockets]
          game_sockets |> table.insert([#(code, new_sockets_list)])
          //send current user to the set_name page
          let assert Ok(_) =
            mist.send_text_frame(player.socket, set_name_page())
          //send everyone else to the set_name page
          // from_list(current_sockets)
          // |> each(fn(other_player: PlayerSocket) {
          //actor.send(other_player.state.subject, "Hi")
          //process.receive(other_player.state.subject, 128) |> io.debug
          // })
          let v = valkey_client()
          let assert Ok(subscribers) =
            radish.publish(
              v,
              "all",
              "<div id=\"page\" class=\"hero bg-base-100 min-h-full\">hi</div>"
                <> game_code,
              128,
            )
          radish.shutdown(v)
          //logging.log(Info, int.to_string(subscribers)<>" subscribers listened.")
          ActorState(O, "", player.state.subject)
        }
      }
    }
    _ -> {
      let assert Ok(_) = mist.send_text_frame(player.socket, wrong_code())
      ActorState(Neither, "", player.state.subject)
    }
  }
}
