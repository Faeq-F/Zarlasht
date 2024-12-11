//// The page seen when trying to join a chat

import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

/// The page used to join a chat
///
/// Composed of a text field to enter the chat code and a button to submit it
///
/// Returns stringified HTML to send to the websocket
///
pub fn join_chat_page() -> String {
  html.div([attribute.id("pageInputs")], [
    html.form([attribute("ws-send", ""), attribute.id("join-chat-form")], [
      html.div([attribute.class("join")], [
        html.input([
          attribute.name("chatCode"),
          attribute.placeholder("Chat Code"),
          attribute.class("input input-bordered join-item"),
        ]),
        html.button(
          [
            attribute.class(
              "btn join-item bg-secondary text-secondary-content hover:bg-accent",
            ),
          ],
          [html.text("Join")],
        ),
      ]),
    ]),
    html.div([attribute.id("errorCode")], []),
  ])
  |> element.to_string
}

/// The error message the user will see if they enter an incorrect code
///
/// Returns stringified HTML to send to the websocket
///
pub fn wrong_code() -> String {
  html.div([attribute.id("errorCode")], [
    html.p([attribute.class("text-sm mt-1 text-error")], [
      html.text("A game does not exist for this code!"),
    ]),
  ])
  |> element.to_string
}
