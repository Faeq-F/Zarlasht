import app/actors/actor_types
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html.{text}
import lustre/element/svg

pub fn game_page() -> String {
  html.div(
    [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
    [
      html.h1([attribute.class("text-5xl font-bold mt-4")], [
        element.text("Pong"),
      ]),
      html.div(
        [
          attribute.class(
            "divider lg:divider-horizontal absolute top-1/2 -translate-y-1/2 h-96",
          ),
        ],
        [],
      ),
      html.div(
        [
          attribute.class(
            "hero-content text-center absolute top-1/2 -translate-y-1/2 min-w-full h-screen pt-16 pb-12",
          ),
        ],
        [
          html.div([attribute.class("grid grid-cols-2 gap-10 w-full h-full")], [
            html.div([attribute.class("card text-center h-full")], [
              html.div(
                [
                  attribute.class("w-4/6 h-1/7 rounded-3xl p-4 pl-36 text-left"),
                  attribute.id("player1"),
                ],
                [],
              ),
              html.div(
                [
                  attribute.class(
                    "m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full",
                  ),
                  attribute.id("game"),
                ],
                [],
              ),
            ]),
            html.div([attribute.class("card text-center h-full")], [
              html.div(
                [
                  attribute.class(
                    "m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full",
                  ),
                  attribute.id("game"),
                ],
                [],
              ),
              html.div(
                [
                  attribute.class(
                    "w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-auto pr-36 text-right",
                  ),
                  attribute.id("player2"),
                ],
                [],
              ),
            ]),
          ]),
        ],
      ),
      html.div([attribute.id("status")], []),
    ],
  )
  |> element.to_string
}

pub fn player(player: actor_types.Player, name: String) -> String {
  case player {
    actor_types.One -> {
      html.div(
        [
          attribute.class("w-4/6 h-1/7 rounded-3xl p-4 pl-36 text-left"),
          attribute.id("player1"),
        ],
        [html.p([attribute.class("inline text-lg")], [text(name)])],
      )
      |> element.to_string
    }
    _ -> {
      html.div(
        [
          attribute.class(
            "w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-auto pr-36 text-right",
          ),
          attribute.id("player2"),
        ],
        [html.p([attribute.class("inline text-lg")], [text(name)])],
      )
      |> element.to_string
    }
  }
}

pub fn empty(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute.class(classes),
      attribute("x", "0px"),
      attribute("y", "0px"),
      attribute("width", "100"),
      attribute("height", "100"),
      attribute("viewBox", "0 0 72 72"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
    ],
    [],
  )
}
