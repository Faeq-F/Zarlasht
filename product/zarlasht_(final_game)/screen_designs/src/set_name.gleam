import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn set_name() -> Element(t) {
  html.div([attribute.id("app")], [
    html.div(
      [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
      [
        html.div(
          [
            attribute.class(
              "hero-content text-center absolute top-1/2 -translate-y-1/2",
            ),
          ],
          [
            html.div([attribute.class("max-w-md")], [
              html.h1(
                [attribute.class("text-7xl font-bold mb-3 font-header ")],
                [html.text("Zarlasht")],
              ),
              html.div([attribute.class("w-full")], [
                html.div([attribute.id("pageInputs")], [
                  html.form([], [
                    html.div([attribute.class("join w-full")], [
                      html.input([
                        attribute.class(
                          "input input-bordered bg-transparent join-item text-xl  w-full",
                        ),
                        attribute.placeholder(" Your Name"),
                      ]),
                      html.button(
                        [
                          attribute.class(
                            "btn join-item bg-transparent hover:bg-transparent text-secondary-content hover:text-accent text-xl  text-shadow",
                          ),
                        ],
                        [
                          html.span([attribute.class("tick font-header ")], [
                            html.text("L"),
                          ]),
                        ],
                      ),
                    ]),
                  ]),
                  html.div([attribute.id("waiting")], [
                    html.p([attribute.class("mt-1  w-full text-info text-xl")], [
                      html.text(
                        "Waiting for the other
                  player...",
                      ),
                    ]),
                  ]),
                ]),
              ]),
            ]),
          ],
        ),
      ],
    ),
  ])
}
