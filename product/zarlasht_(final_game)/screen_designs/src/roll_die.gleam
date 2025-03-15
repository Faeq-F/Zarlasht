import components/bottom_bar.{bottom_bar}
import components/lucide_lustre.{
  circle_x, dice_5, info as info_icon, map, messages_square, shield,
}
import gleam/string.{join}
import layout.{stats}
import lustre/attribute.{class, style}
import lustre/element.{type Element}

import lustre/element/html.{button, div, li, p, text, ul}

pub fn roll_die() -> Element(t) {
  div(
    [
      class("!text-left !absolute !z-[999]"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full z-30 absolute")], [bottom_bar(info(), buttons())]),
      die_section(),
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

fn die_section() {
  div([class("flex")], [
    div(
      [
        class("!inline"),
        style([
          #("width", "50%"),
          #("height", "90vh"),
          #("align-content", "center"),
        ]),
      ],
      [roll_section()],
    ),
    div(
      [
        class("!inline"),
        style([
          #("width", "50%"),
          #("height", "90vh"),
          #("align-content", "center"),
        ]),
      ],
      [info_panel()],
    ),
  ])
}

fn roll_section() {
  div([class("")], [
    div([class("flex justify-center items-center")], [
      div(
        [
          class(
            "btn !bg-gray-100/60 !border !border-neutral-500 font-text !text-lg",
          ),
          style([#("cursor", "default")]),
        ],
        [
          shield([class("!mr-[10px]")]),
          text("You are currently rolling for defence strategy"),
        ],
      ),
    ]),
    div([class("flex justify-center items-center")], [
      dice_5([class("w-56 h-56")]),
    ]),
    div([class("flex justify-center items-center")], [
      button(
        [
          class(join(
            [
              "btn border font-text !text-xl", "bg-black/15 hover:bg-black/30",
              "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
              "border-black/40 text-current", "transition-all duration-500",
            ],
            " ",
          )),
        ],
        [text("Roll")],
      ),
    ]),
    div([class("flex justify-center items-center")], [
      div(
        [
          class(
            "!mt-4 w-96 pl-4 py-4 rounded-xl !bg-gray-100/60 !border !border-neutral-500 font-text !text-lg",
          ),
          style([#("cursor", "default")]),
        ],
        [
          p([class("font-text")], [text("Attack type: 6 (Critical hit)")]),
          p([class("font-text")], [text("Attack Damage: 4")]),
        ],
      ),
    ]),
  ])
}

fn info_panel() {
  div(
    [
      class(
        "rounded-xl !bg-gray-100/60 !border !border-neutral-500 font-header !text-lg !mx-12",
      ),
      style([#("cursor", "default"), #("height", "50%")]),
    ],
    [
      info_icon([class("w-12 !pt-4 h-12"), style([#("margin", "0 auto")])]),
      p([class("text-center !my-4 text-3xl")], [text("The battle dice")]),
      ul(
        [
          style([
            #("list-style", "circle"),
            #("width", "90%"),
            #("margin", "0 auto"),
          ]),
          class("font-text"),
        ],
        [
          li([], [text("You will first roll a die for your attack type")]),
          li([], [text("This will be followed by a roll for attack damage")]),
          li([], [
            text(
              "Different attack types will have different damage multipliers",
            ),
          ]),
          li([], [
            text(
              "If you roll a 6 for attack type, you will get a critical hit and deal double damage",
            ),
          ]),
          li([], [
            text(
              "If you roll 3 or below, you will have a lighter attack, allowing you to roll again and compound the damage",
            ),
          ]),
          li([], [
            text(
              "After these rolls, you will roll for defence strategy, taking off damage from your enemy's attacks",
            ),
          ]),
        ],
      ),
    ],
  )
}
