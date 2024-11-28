import app/pages/created_game.{created_game_page}
import app/socket_types.{type ActorState, type PlayerSocket, ActorState, X}
import carpenter/table
import gleam/int
import logging.{Info}
import mist

pub fn on_create_game(player: PlayerSocket) -> ActorState {
  let game_code = generate_game_code(player)
  let assert Ok(_) =
    mist.send_text_frame(player.socket, created_game_page(game_code))
  ActorState(X, "", player.state.subject)
}

fn generate_game_code(player: PlayerSocket) -> Int {
  let assert Ok(game_sockets) = table.ref("game_sockets")
  let game_code = int.random(9998)
  case game_sockets |> table.lookup(game_code) {
    [] -> {
      game_sockets
      |> table.insert([#(game_code, [player])])
      logging.log(Info, "New game created; " <> int.to_string(game_code))
      game_code
    }
    _ -> generate_game_code(player)
  }
}
