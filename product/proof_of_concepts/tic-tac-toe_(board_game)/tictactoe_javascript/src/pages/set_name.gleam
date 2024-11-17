import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html
import pages/svg_elements.{tick}

pub fn set_name_page() -> String {
  html.div(
    [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
    [
      html.h1([attribute.class("text-5xl font-bold mt-4")], [
        element.text("Tic-Tac-Toe"),
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
                        [tick("w-5 h-5 fill-current")],
                      ),
                    ]),
                  ],
                ),
                html.div([attribute.id("waiting")], []),
              ]),
            ]),
          ]),
        ],
      ),
    ],
  )
  |> element.to_string
}

pub fn waiting() -> String {
  html.div([attribute.id("waiting")], [
    html.p([attribute.class("text-sm mt-1 text-info")], [
      html.text("Waiting for the other player..."),
    ]),
  ])
  |> element.to_string
}
