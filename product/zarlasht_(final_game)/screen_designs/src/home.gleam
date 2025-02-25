import components/bottom_bar.{bottom_bar}
import lustre/attribute.{attribute, class, style}
import lustre/element.{type Element}
import lustre/element/html.{div, h1, text}

pub fn home() -> Element(t) {
  div(
    [
      class("!text-left !absolute"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full")], [
        bottom_bar("home"),
        h1([class("!text-9xl font-header p-4")], [text("Zarlasht")]),
      ]),
    ],
  )
}
