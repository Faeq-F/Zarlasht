//// The page the user sees when they create a game

import gleam/int
import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

/// The page the user sees when they create a game
///
/// Provides them with the game_code to share with others
///
pub fn created_game_page(game_code: Int) -> String {
  html.div(
    [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
    [
      html.h1([attribute.class("text-5xl font-bold fixed top-0 mt-4")], [
        element.text("Pong"),
      ]),
      html.div(
        [
          attribute.class(
            "hero-content text-center absolute top-1/2 -translate-y-1/2",
          ),
        ],
        [
          html.div([attribute.class("max-w-md")], [
            html.div([], [
              html.p([attribute.class("font-bold text-6xl mb-3 text-success")], [
                html.text(int.to_string(game_code)),
              ]),
              html.p([attribute.class("font-bold text-xl")], [
                html.text("Share this code"),
                html.br([]),
                html.text("with a friend!"),
              ]),
            ]),
          ]),
        ],
      ),
    ],
  )
  |> element.to_string
}
