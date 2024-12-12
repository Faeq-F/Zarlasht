//// The page seen when trying to join a game

import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

/// The page used to join a game
///
/// Composed of a text field to enter the game code and a button to submit it
///
/// Returns stringified HTML to send to the websocket
///
pub fn join_game_page() -> String {
  html.div([attribute.id("pageInputs")], [
    html.form([attribute("ws-send", ""), attribute.id("join-game-form")], [
      html.div([attribute.class("join")], [
        html.input([
          attribute.name("gameCode"),
          attribute.placeholder("Game Code"),
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
