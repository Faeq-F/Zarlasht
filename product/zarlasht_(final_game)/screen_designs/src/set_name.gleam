import components/bottom_bar.{bottom_bar}
import gleam/string.{join}
import lustre/attribute.{class, style}
import lustre/element.{type Element}
import lustre/element/html.{button, div, h1, text}

pub fn set_name() -> Element(t) {
  div(
    [
      class("!text-left !absolute !z-[999]"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
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
      class("btn !bg-gray-100  font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("Please enter your name")],
  )
}

fn buttons() {
  [
    html.input([
      attribute.class(
        "input input-bordered bg-transparent join-item text-xl  w-full !border-0 font-text !text-xl",
      ),
      attribute.placeholder("Your name"),
    ]),
    button(
      [
        class(join(
          [
            "btn border lg:inline-flex !rounded-full !rounded-l-none w-40",
            "bg-black/15 hover:bg-black/30",
            "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
            "border-black/40 text-current font-text !text-xl",
            "transition-all duration-500",
          ],
          " ",
        )),
      ],
      [text("Set Name")],
    ),
  ]
}
