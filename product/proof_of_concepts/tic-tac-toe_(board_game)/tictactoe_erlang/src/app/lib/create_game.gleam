import app/pages/created_game.{created_game_page}
import app/socket_types.{type PlayerSocket}
import gleam/dict
import gleam/int
import glemo
import mist

pub fn on_create_game(player: PlayerSocket) -> Nil {
  let game_code = generate_game_code(player)
  let assert Ok(_) =
    mist.send_text_frame(player.socket, created_game_page(game_code))
  Nil
}

fn generate_game_code(player: PlayerSocket) -> Int {
  let game_sockets = dict.new() |> glemo.memo("cache", fn(dict) { dict })
  let game_code = int.random(9998)
  case game_sockets |> dict.has_key(game_code) {
    True -> generate_game_code(player)
    _ -> {
      glemo.invalidate_all("cache")
      game_sockets
      |> dict.insert(game_code, [player])
      |> glemo.memo("cache", fn(dict) { dict })
      game_code
    }
  }
}
// need to update actor state
