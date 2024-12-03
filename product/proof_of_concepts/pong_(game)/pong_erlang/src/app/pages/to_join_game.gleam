import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

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

pub fn wrong_code() -> String {
  html.div([attribute.id("errorCode")], [
    html.p([attribute.class("text-sm mt-1 text-error")], [
      html.text("A game does not exist for this code!"),
    ]),
  ])
  |> element.to_string
}
