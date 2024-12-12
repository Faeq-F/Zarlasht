import app/pages/to_join_chat.{join_chat_page, wrong_code}
import glacier/should

pub fn join_chat_page_test() {
  join_chat_page()
  |> should.equal(
    "<div id=\"pageInputs\"><form ws-send id=\"join-chat-form\"><div class=\"join\"><input name=\"chatCode\" placeholder=\"Chat Code\" class=\"input input-bordered join-item\"><button class=\"btn join-item bg-secondary text-secondary-content hover:bg-accent\">Join</button></div></form><div id=\"errorCode\"></div></div>",
  )
}

pub fn wrong_code_test() {
  wrong_code()
  |> should.equal(
    "<div id=\"errorCode\"><p class=\"text-sm mt-1 text-error\">A chat does not exist for this code!</p></div>",
  )
}
