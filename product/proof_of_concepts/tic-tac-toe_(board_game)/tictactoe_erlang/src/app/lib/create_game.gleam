import app/pages/created_game.{created_game_page}
import app/socket_types.{type ActorState, type PlayerSocket, ActorState, X}
import gleam/dict
import gleam/int
import glemo
import mist

pub fn on_create_game(player: PlayerSocket) -> ActorState {
  let game_code = generate_game_code(player)
  let assert Ok(_) =
    mist.send_text_frame(player.socket, created_game_page(game_code))
  ActorState(X, "")
}

fn generate_game_code(player: PlayerSocket) -> Int {
  //grab dict from cache
  let game_sockets = dict.new() |> glemo.memo("cache", fn(dict) { dict })
  // generate new game_code & check if it is already a game
  let game_code = int.random(9998)
  case game_sockets |> dict.has_key(game_code) {
    True -> generate_game_code(player)
    _ -> {
      //delete the dict from cache
      glemo.invalidate_all("cache")
      //update the prev. dict and save that in the cache
      game_sockets
      |> dict.insert(game_code, [player])
      |> glemo.memo("cache", fn(dict) { dict })
      game_code
    }
  }
}
