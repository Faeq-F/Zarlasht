import app/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueParticipant,
  WebsocketActorState, X,
}
import app/pages/created_game.{created_game_page}
import carpenter/table
import gleam/erlang/process
import gleam/int
import logging.{Info}
import mist

pub fn on_create_game(player: PlayerSocket) -> WebsocketActorState {
  let game_code = generate_game_code(player)
  process.send(
    player.state.director_subject,
    EnqueueParticipant(game_code, X, player.state.ws_subject),
  )
  let assert Ok(_) =
    mist.send_text_frame(player.socket, created_game_page(game_code))
  WebsocketActorState(..player.state, player: X)
}

fn generate_game_code(player: PlayerSocket) -> Int {
  let assert Ok(waiting_games) = table.ref("waiting_games")
  let game_code = int.random(9999)
  // Games with the same codes can exist;
  // They just cannot be waiting for a joining player at the same time
  case waiting_games |> table.lookup(game_code) {
    [] -> {
      waiting_games
      |> table.insert([#(game_code, "Waiting for a player to join")])
      logging.log(Info, "New game created; " <> int.to_string(game_code))
      game_code
    }
    _ -> generate_game_code(player)
  }
}
