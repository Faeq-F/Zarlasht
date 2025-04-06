import app/pages/components/bottom_bar.{bottom_bar}
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, style}
import lustre/element.{type Element}
import lustre/element/html.{button, div, h1, text}

pub fn home() -> Element(t) {
  div(
    [
      class("!text-left !absolute !z-[999]"),
      style([
        #("width", "calc(100% - 2rem)"),
        #("height", "calc(100% - 2rem)"),
        #("background-image", "url(/static/home.png)"),
        #("background-size", "cover"),
        #("background-repeat", "no-repeat"),
        #("background-position", "right"),
      ]),
    ],
    [
      div([class("!w-full")], [
        bottom_bar(info(), buttons()),
        h1([class("!text-9xl font-header p-4")], [text("Zarlasht")]),
      ]),
    ],
  )
}

fn info() {
  div(
    [
      class("btn !bg-gray-100 font-header !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("Zarlasht")],
  )
}

fn buttons() {
  [
    button(
      [
        class(join(
          [
            "btn border font-text !text-xl lg:inline-flex",
            "bg-black/15 hover:bg-black/30",
            "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
            "border-black/40 text-current", "transition-all duration-500",
          ],
          " ",
        )),
        id("create"),
        attribute("ws-send", ""),
      ],
      [text("Create a Game")],
    ),
    button(
      [
        class(join(
          [
            "btn border font-text !text-xl lg:inline-flex !rounded-full !rounded-l-none",
            "bg-black/15 hover:bg-black/30",
            "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
            "border-black/40 text-current", "transition-all duration-500",
          ],
          " ",
        )),
        id("join"),
        attribute("ws-send", ""),
      ],
      [text("Join a Game")],
    ),
  ]
}
