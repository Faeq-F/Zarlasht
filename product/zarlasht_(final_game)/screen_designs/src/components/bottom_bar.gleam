import components/information_modal.{info_modal}
import components/lucide_lustre.{copy, github, info}
import components/theme_switch.{theme_switch}
import gleam/string.{join}
import lustre/attribute.{
  attribute, class, href, id, rel, src, style, target, type_,
}
import lustre/element.{fragment}
import lustre/element/html.{a, br, button, div, img, label, p, text}
import lustre/element/svg

import gleam/int

pub fn bottom_bar(screen) {
  fragment([
    div(
      [
        id("BottomBar"),
        class("!fixed !bottom-[1.5rem]"),
        style([#("width", "calc(100% - 2rem)")]),
      ],
      [
        div(
          [
            class(join(
              [
                "!flex !rounded-full !ml-[0.5rem] !mr-[0.5rem]",
                "!items-center !justify-between !py-2 !px-2",
                "!bg-black/10 !border !border-black/15",
                "!dark:bg-white/15 !dark:border-white/15",
                "!backdrop-blur-[6px]",
                "!dark:shadow-[0px_10px_10px_-8px_rgba(18,18,23,0.02),0px_2px_2px_-1.5px_rgba(18,18,23,0.02),0px_1px_1px_-0.5px_rgba(18,18,23,0.02)]",
                "!shadow-[0px_10px_10px_-8px_rgba(237,237,232,0.02),0px_2px_2px_-1.5px_rgba(237,237,232,0.02),0px_1px_1px_-0.5px_rgba(237,237,232,0.02)]",
                "!transition-all !duration-500",
              ],
              " ",
            )),
          ],
          [
            div([class("w-96 flex justify-start")], [
              theme_switch(),
              info_modal(),
            ]),
            case screen {
              "home" -> home_info()
              "created_game" -> created_game_info()
              "join_game" -> join_game_info()
              "set_name" -> set_name_info()
              _ -> fragment([])
            },
            div([class("w-96 flex justify-end")], [
              div(
                [
                  class("btn-group  btn-group-scrollable"),
                  style([#("height", "2.5rem")]),
                ],
                case screen {
                  "home" -> home_buttons()
                  "created_game" -> created_game_buttons(3978)
                  "join_game" -> join_game_buttons()
                  "set_name" -> set_name_buttons()
                  _ -> []
                },
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}

fn home_buttons() {
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
      ],
      [text("Join a Game")],
    ),
  ]
}

fn created_game_buttons(game_code) {
  [
    div([class("popover popover-border contents")], [
      label(
        [
          class(join(
            [
              "popover-trigger btn border !rounded-r-none !rounded-full",
              "bg-black/15 hover:bg-black/30",
              "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
              "border-black/40 text-current", "transition-all duration-500",
            ],
            " ",
          )),
          attribute("tabindex", "0"),
          attribute(
            "@click",
            "navigator.clipboard.writeText(\""
              <> int.to_string(game_code)
              <> "\")",
          ),
        ],
        [copy([])],
      ),
      div(
        [
          class(
            "popover-content w-32 popover-top-left !fixed font-text !bg-green-300",
          ),
          attribute("tabindex", "0"),
          style([#("width", "fit-content")]),
        ],
        [div([], [text("Copied game code")])],
      ),
    ]),
    button([class(join(["btn !rounded-r-full font-text !text-xl"], " "))], [
      text("Start Game"),
    ]),
  ]
}

fn home_info() {
  div(
    [
      class("btn !bg-gray-100 font-header !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("Zarlasht")],
  )
}

fn created_game_info() {
  div(
    [
      class("btn !bg-gray-100 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("minimum of 5 players")],
  )
}

fn join_game_info() {
  div(
    [
      class("btn !bg-gray-100 !text-red-500 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("A game does not exist for this code")],
  )
}

fn join_game_buttons() {
  [
    html.input([
      attribute.class(
        "input input-bordered bg-transparent join-item text-xl  w-full !border-0 font-text !text-xl",
      ),
      attribute.placeholder(" Game Code"),
    ]),
    button(
      [
        class(join(
          [
            "btn border lg:inline-flex !rounded-full !rounded-l-none",
            "bg-black/15 hover:bg-black/30",
            "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
            "border-black/40 text-current font-text !text-xl",
            "transition-all duration-500",
          ],
          " ",
        )),
      ],
      [text("Join")],
    ),
  ]
}

fn set_name_info() {
  div(
    [
      class("btn !bg-gray-100  font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("Please enter your name")],
  )
}

fn set_name_buttons() {
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
