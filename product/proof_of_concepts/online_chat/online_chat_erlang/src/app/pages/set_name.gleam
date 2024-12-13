//// The page seen when trying to set your name

import lucide_lustre.{check}
import lustre/attribute.{attribute, class}
import lustre/element
import lustre/element/html

/// The page used to set a user's name
///
/// Composed of a text field to enter your name and a button to submit it
///
/// Returns stringified HTML to send to the websocket
///
pub fn set_name_page() -> String {
  html.div(
    [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
    [
      html.h1([attribute.class("text-5xl font-bold mt-4")], [
        element.text("Online Chat"),
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
              html.p([attribute.class("font-bold text-3xl mb-3")], [
                html.text("What's your name?"),
              ]),
              html.div([attribute.id("pageInputs")], [
                html.form(
                  [attribute("ws-send", ""), attribute.id("set-name-form")],
                  [
                    html.div([attribute.class("join")], [
                      html.input([
                        attribute.name("name"),
                        attribute.placeholder("Your name"),
                        attribute.class("input input-bordered join-item"),
                      ]),
                      html.button(
                        [
                          attribute.class(
                            "btn join-item bg-secondary text-secondary-content hover:bg-accent",
                          ),
                        ],
                        [check([class("w-5 h-5")])],
                      ),
                    ]),
                  ],
                ),
              ]),
            ]),
          ]),
        ],
      ),
    ],
  )
  |> element.to_string
}

/// The error message the user will see if they do not enter a name
///
/// Returns stringified HTML to send to the websocket
///
pub fn empty_name() -> String {
  html.div([attribute.id("waiting")], [
    html.p([attribute.class("text-sm mt-1 text-error")], [
      html.text("You cannot have an empty name!"),
    ]),
  ])
  |> element.to_string
}
