import app/pages/created_game.{created_game_page}
import glacier/should

pub fn crteated_game_page_test() {
  created_game_page(12)
  |> should.equal(
    "<div id=\"page\" class=\"hero bg-base-100 min-h-full\"><h1 class=\"text-5xl font-bold fixed top-0 mt-4\">Pong</h1><div class=\"hero-content text-center absolute top-1/2 -translate-y-1/2\"><div class=\"max-w-md\"><div><p class=\"font-bold text-6xl mb-3 text-success\">12</p><p class=\"font-bold text-xl\">Share this code<br>with a friend!</p></div></div></div></div>",
  )
}
