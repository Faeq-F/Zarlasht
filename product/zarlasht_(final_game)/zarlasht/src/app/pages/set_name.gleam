//// The page that lets a player set their name

import app/pages/components/bottom_bar.{bottom_bar}
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, style}
import lustre/element
import lustre/element/html.{button, div, h1, text}

/// The set name page
///
pub fn set_name_page() {
  div([id("page"), class("h-full w-full")], [
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
    ),
  ])
  |> element.to_string()
}

/// The information to show the player
///
fn info() {
  div(
    [
      id("name_info"),
      class("btn !bg-gray-100  font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("Please enter your name")],
  )
}

/// The information to show when they input an empty name
///
pub fn incorrect_info() {
  div(
    [
      id("name_info"),
      class("btn !bg-gray-100 !text-red-500 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("You cannot have an empty name!")],
  )
}

/// The buttons to show on the bottom bar
///
fn buttons() {
  [
    html.form(
      [
        attribute("ws-send", ""),
        id("set-name-form"),
        class("btn-group btn-group-scrollable"),
      ],
      [
        html.input([
          attribute.class(
            "input input-bordered bg-transparent join-item text-xl  w-full !border-0 font-text !text-xl",
          ),
          attribute.placeholder("Your name"),
          attribute.name("name"),
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
      ],
    ),
  ]
}
