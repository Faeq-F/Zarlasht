import app/pages/to_join_game.{join_game_page, wrong_code}
import glacier/should

pub fn join_chat_page_test() {
  join_game_page()
  |> should.equal(
    "<div id=\"pageInputs\"><form ws-send id=\"join-game-form\"><div class=\"join\"><input name=\"gameCode\" placeholder=\"Game Code\" class=\"input input-bordered join-item\"><button class=\"btn join-item bg-secondary text-secondary-content hover:bg-accent\">Join</button></div></form><div id=\"errorCode\"></div></div>",
  )
}

pub fn wrong_code_test() {
  wrong_code()
  |> should.equal(
    "<div id=\"errorCode\"><p class=\"text-sm mt-1 text-error\">A game does not exist for this code!</p></div>",
  )
}
