import lustre/element.{type Element}

import app/actors/actor_types.{type Player}
import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{
  dices, info as info_icon, map, messages_square, radar, sword,
}

import app/pages/layout.{stats as info_stats}
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, style}

import lustre/element/html.{button, div, li, p, text, ul}

pub fn game(stats: Player) {
  div([id("page"), class("h-full w-full")], [
    div(
      [
        class("!text-left !absolute !z-[999]"),
        style([
          #("width", "calc(100% - 2rem)"),
          #("height", "calc(100% - 2rem)"),
        ]),
      ],
      [
        div([class("!w-full z-30 absolute")], [
          bottom_bar(info(stats), buttons()),
        ]),
        info_section(),
      ],
    ),
  ])
  |> element.to_string
}

fn info(stats: Player) {
  div(
    [
      class("btn !bg-gray-100 font-header !text-lg"),
      style([#("cursor", "default")]),
    ],
    [info_stats(stats)],
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
        attribute("ws-send", ""),
        id("go_to_chats"),
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
        attribute("ws-send", ""),
        id("go_to_map"),
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
        attribute("ws-send", ""),
        id("go_to_dice_roll"),
      ],
      [dices([])],
    ),
  ]
}

fn info_section() {
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
      [area_panel()],
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

fn area_panel() {
  div([class("")], [
    div([class("flex  items-center")], [
      div(
        [
          class("!ml-8 font-subheader items-end inline-flex !text-6xl"),
          style([#("cursor", "default")]),
        ],
        [
          radar([class("!w-18 !h-18 !mr-[10px]")]),
          //TODO - dynamic
          text("Ambush!"),
        ],
      ),
    ]),
    div([class("flex justify-center items-center")], [
      div(
        [
          class("!ml-8 font-text !text-lg !text-left !my-6"),
          style([#("cursor", "default")]),
        ],
        [
          //TODO - dynamic
          text(
            "You are on the border of the forest and a neighboring tribe spotted you. You are being ambushed and must fight your way out!",
          ),
        ],
      ),
    ]),
    div([class("flex justify-center items-center")], [
      div(
        [
          class(
            "!mt-4 w-96 pl-4 py-4 rounded-xl !bg-gray-100/60 !border !border-neutral-500 font-text !text-lg",
          ),
          style([#("cursor", "default"), #("height", "60vh"), #("width", "90%")]),
        ],
        [
          p([class("text-center !my-4 text-3xl")], [text("Battle")]),
          div([class("flex")], [
            div(
              [
                class("!inline"),
                style([
                  #("width", "40%"),
                  #("height", "50vh"),
                  #("align-content", "center"),
                ]),
              ],
              [text("enemy image")],
            ),
            div(
              [
                class("!inline content-center"),
                style([#("width", "60%"), #("height", "50vh")]),
              ],
              [
                p([class("font-subheader inline-flex text-4xl")], [
                  sword([class("self-center !mr-1 w-8 h-8")]),
                  //TODO - dynamic
                  text("Expert Swordsman"),
                ]),
                ul(
                  [
                    style([
                      #("list-style", "circle"),
                      #("width", "90%"),
                      #("margin", "0 auto"),
                    ]),
                    class("font-text"),
                  ],
                  expert_swordsman_points(),
                ),
                call_allies_btn(),
              ],
            ),
          ]),
        ],
      ),
    ]),
  ])
}

fn expert_swordsman_points() {
  [
    li([], [
      text(
        "The Expert Swordsman is a skilled warrior who has been trained in the art of combat since he was a child. He is a formidable opponent and will not go down easily.",
      ),
    ]),
    li([], [
      text("If he is not defeated quickly, he will call for reinforcements"),
    ]),
    li([], [text("If he is too strong, you can call for allies to help you")]),
  ]
}

fn call_allies_btn() {
  button(
    [
      class(join(
        [
          "btn !border font-text !text-xl !mt-4",
          "bg-black/15 hover:bg-black/30",
          "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
          "border-black/40 text-current", "transition-all duration-500",
        ],
        " ",
      )),
    ],
    [text("Call Allies to help")],
  )
}

fn info_panel() {
  div(
    [
      class(
        "rounded-xl !bg-gray-100/60 !border !border-neutral-500 font-header !text-lg !mx-12",
      ),
      style([#("cursor", "default"), #("height", "90%")]),
    ],
    [
      info_icon([class("w-12 !pt-4 h-12"), style([#("margin", "0 auto")])]),
      p([class("text-center !my-4 text-3xl")], [text("Updates")]),
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
          // li([], [text("Your Ally, John, has been injured badly and retreated")]),
        // li([], [text("You defeated 4 enemies within your party")]),
        // li([], [text("Something else")]),
        ],
      ),
    ],
  )
}
