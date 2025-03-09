import components/bottom_bar.{bottom_bar}
import components/lucide_lustre.{
  circle_user_round, circle_x, map, messages_square, scan,
}
import lustre/element.{type Element}

import gleam/list
import gleam/result
import gleam/string.{join}
import layout.{stats}
import lustre/attribute.{attribute, class, id, name, role, style, type_}

import lustre/element/html.{br, button, div, h1, label, p, span, text, textarea}

pub fn roll_die() -> Element(t) {
  div(
    [
      class("!text-left !absolute"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full z-30 absolute")], [bottom_bar(info(), buttons())]),
      map_section(),
    ],
  )
}

fn info() {
  div(
    [
      class("btn !bg-gray-100 font-header !text-lg"),
      style([#("cursor", "default")]),
    ],
    [stats()],
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
      ],
      [messages_square([])],
    ),
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
      ],
      [map([])],
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
      ],
      [circle_x([])],
    ),
  ]
}
