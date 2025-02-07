//// The home page of the site

import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

/// The home page of the site
///
/// A page with two buttons; one for creating a game and another for joining a game
///
pub fn root() -> Element(t) {
  html.div([attribute.class("hero bg-base-100 min-h-full")], [
    html.div(
      [
        attribute.class(
          "hero-content text-center absolute top-1/2 -translate-y-1/2",
        ),
      ],
      [
        html.div([attribute.class("max-w-md")], [
          html.h1(
            [
              attribute.class(
                "dark:text-white text-5xl font-bold mb-3 font-header",
              ),
            ],
            [element.text("Zarlasht")],
          ),
          html.div([attribute.class("join"), attribute.id("pageInputs")], [
            html.button(
              [
                attribute("ws-send", ""),
                attribute.id("create"),
                attribute("data-theme", "forest"),
                attribute.class(
                  "btn join-item bg-secondary text-secondary-content hover:bg-accent",
                ),
              ],
              [text("Create a game")],
            ),
            html.button(
              [
                attribute("ws-send", ""),
                attribute.id("join"),
                attribute("data-theme", "forest"),
                attribute.class(
                  "btn join-item bg-neutral hover:bg-accent hover:text-secondary-content",
                ),
              ],
              [text("Join a game")],
            ),
          ]),
        ]),
      ],
    ),
  ])
}
