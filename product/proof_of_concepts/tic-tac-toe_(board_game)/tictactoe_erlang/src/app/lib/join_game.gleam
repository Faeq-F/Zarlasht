import app/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueParticipant, O,
  WebsocketActorState,
}
import app/pages/to_join_game.{join_game_page, wrong_code}
import carpenter/table
import gleam/dict
import gleam/erlang/process
import gleam/int
import gleam/json.{int}
import juno
import mist

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
      let assert Ok(waiting_games) = table.ref("waiting_games")

      case waiting_games |> table.lookup(code) {
        [] -> {
          let assert Ok(_) = mist.send_text_frame(player.socket, wrong_code())
          player.state
        }
        _ -> {
          waiting_games |> table.delete(code)
          process.send(
            player.state.director_subject,
            EnqueueParticipant(code, O, player.state.ws_subject),
          )
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
