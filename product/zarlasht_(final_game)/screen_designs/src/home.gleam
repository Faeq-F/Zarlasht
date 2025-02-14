import components/bottom_bar.{bottom_bar}
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn home() -> Element(t) {
  html.div([attribute.id("app")], [
    html.div(
      [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
      [
        html.div(
          [
            attribute.class(
              "hero-content text-left absolute top-1/2 -translate-y-1/2 w-full",
            ),
          ],
          [
            html.div([attribute.class("w-full")], [
              bottom_bar(),
              html.h1(
                [attribute.class("text-9xl font-bold mb-3 font-header ")],
                [html.text("Zarlasht")],
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}
