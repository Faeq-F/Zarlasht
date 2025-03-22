import app/actors/actor_types.{type Player}
import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{
  circle_user_round, circle_x, dices, messages_square, scan,
}
import app/pages/layout.{stats as info_stats}
import gleam/list
import gleam/result
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, style}
import lustre/element.{type Element}
import lustre/element/html.{button, div, h1, text}

pub fn map(stats: Player) {
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
        map_section(),
      ],
    ),
  ])
  |> element.to_string
}

fn header(chat: String) {
  div([], [h1([class("font-header !text-4xl text-center !mt-8")], [text(chat)])])
}

fn map_section() {
  div(
    [
      class(
        "relative flex flex-grow flex-col px-12 justify-end Chat overflowy-scroll",
      ),
      style([#("height", "calc(100% - 4.5rem)")]),
    ],
    [
      header("Map"),
      div(
        [
          attribute("ws-send", ""),
          attribute("hx-trigger", "every 2s"),
          id("map"),
          style([
            #("grid-template-columns", "repeat(55, 3vh)"),
            #("grid-template-rows", "repeat(22, 3vh)"),
            #("width", "fit-content"),
            #("margin", "0 auto"),
          ]),
          class("grid gap-0 !border !border-neutral-500 rounded-xl"),
        ],
        generate_grid([
          #("John", 3, 5),
          #("John", 38, 17),
          #("Faeq", 54, 8),
          #("John", 34, 20),
          #("John", 7, 12),
        ]),
      ),
      key(),
    ],
  )
}

//TODO - tooltips for key

fn key() {
  div([class("flex justify-center !mt-[2.5vh] !mb-[2.5vh]")], [
    div([class("!inline")], [
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-amber-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Paths")]),
      ]),
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-emerald-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Beginning of trail")]),
      ]),
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-pink-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [
          text("Sacred Archery grounds (end of trail)"),
        ]),
      ]),
    ]),
    //
    div([class("font-subheader !inline !mr-4 !ml-[30vw] content-center")], [
      text("Obstacles"),
    ]),
    //
    div([class("!inline")], [
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-red-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Enemy Tribes")]),
      ]),
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-cyan-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Cemetary")]),
      ]),
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-teal-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Dark ritual circles")]),
      ]),
    ]),
    div([class("!inline !ml-4")], [
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-violet-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Perilous Ravines")]),
      ]),
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-lime-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Mystic Fog Patches")]),
      ]),
      div([], [
        div([class("!inline")], [
          scan([class("w-[3vh] h-[3vh] !inline bg-sky-500/50 rounded-lg")]),
        ]),
        div([class("font-text !inline !ml-2")], [text("Rival Cult Ambush")]),
      ]),
    ]),
  ])
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
        id("go_to_dice_roll"),
      ],
      [dices([])],
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
        id("go_to_home"),
      ],
      [circle_x([])],
    ),
  ]
}

fn generate_grid(player_positions: List(#(String, Int, Int))) {
  let grid = [
    [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0,
    ],
    [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
      7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6,
      6, 0, 0, 0, 0,
    ],
    [
      0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6,
      6, 0, 0, 0, 0,
    ],
    [
      0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 9,
      9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4,
      1, 0, 0, 0, 0,
    ],
    [
      0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 1, 0, 0, 9,
      9, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 0,
    ],
    [
      0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 1, 0, 0, 9,
      9, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 0, 0, 0, 0,
    ],
    [
      0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
      0, 0, 1, 6, 6, 4, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
      1, 0, 0, 0, 0,
    ],
    [
      0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0,
      0, 0, 1, 6, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 0,
    ],
    [
      0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0,
      1, 4, 4, 4, 4,
    ],
    [
      0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 4, 1, 0, 0, 0,
      0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0,
      1, 4, 4, 4, 4,
    ],
    [
      0, 0, 0, 0, 0, 0, 8, 8, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 4, 1, 0, 0, 0,
      0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
      1, 4, 4, 4, 4,
    ],
    [
      0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 1, 1, 6, 6, 1, 1, 1, 1, 1, 0, 0, 0,
      0, 0, 0, 0, 0, 1, 7, 1, 1, 0, 0, 0, 0, 0, 0, 1, 8, 8, 8, 8, 8, 1, 1, 7, 1,
      8, 1, 1, 1, 0,
    ],
    [
      0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 1, 1, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0,
      0, 0, 0, 1, 0,
    ],
    [
      0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0,
      0, 0, 0, 1, 0,
    ],
    [
      0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0,
      0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 6, 6, 0,
      0, 0, 0, 1, 0,
    ],
    [
      0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1,
      1, 1, 8, 8, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 6, 6, 1,
      0, 0, 0, 1, 0,
    ],
    [
      0, 4, 1, 1, 1, 0, 0, 1, 6, 6, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
      1, 1, 8, 8, 4, 1, 1, 1, 6, 6, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1,
      1, 1, 0, 1, 0,
    ],
    [
      0, 1, 1, 1, 1, 0, 0, 1, 6, 6, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 1, 4, 4, 4, 4, 4, 4, 6, 6, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
      1, 1, 0, 1, 4,
    ],
    [
      2, 2, 2, 2, 1, 1, 7, 1, 1, 4, 4, 4, 0, 0, 0, 0, 1, 1, 0, 0, 0, 9, 9, 0, 0,
      0, 1, 4, 4, 4, 4, 4, 4, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
      1, 3, 3, 3, 3,
    ],
    [
      2, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 9, 9, 1, 1,
      1, 1, 1, 0, 0, 5, 5, 5, 5, 5, 1, 1, 1, 0, 0, 0, 4, 1, 1, 1, 0, 0, 0, 0, 0,
      0, 3, 3, 3, 3,
    ],
    [
      2, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 0, 0,
      0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
      1, 3, 3, 3, 3,
    ],
    [
      2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      4, 3, 3, 3, 3,
    ],
  ]
  list.flatten(
    list.index_map(grid, fn(x, i) {
      list.index_map(x, fn(y, j) {
        let player =
          list.filter(player_positions, fn(z) { z.1 == j && z.2 == i })
        let content = case list.length(player) == 1 {
          True -> {
            //would get color from game state
            let user_color = case
              result.unwrap(list.first(player), #("", 0, 0)).0
            {
              "John" -> "red"
              _ -> "indigo"
            }
            element.fragment([
              circle_user_round([
                class("peer w-[3vh] h-[3vh] stroke-[" <> user_color <> "]"),
              ]),
              div(
                [
                  attribute.role("tooltip"),
                  attribute.class(
                    "pointer-events-none w-fit relative bottom-0 mb-2 left-1/2 -translate-x-1/2 z-10 flex w-64 flex-col gap-1 rounded-sm bg-white p-2.5 text-xs font-text opacity-0 transition-all ease-out peer-hover:opacity-100 peer-focus:opacity-100",
                  ),
                ],
                [text(result.unwrap(list.first(player), #("", 0, 0)).0)],
              ),
            ])
          }
          _ -> text("")
        }
        //neutral color for unseen parts of the map
        case y {
          1 -> div([class("w-[3vh] h-[3vh] bg-amber-500/50")], [content])
          2 -> div([class("w-[3vh] h-[3vh] bg-emerald-500/50")], [content])
          3 -> div([class("w-[3vh] h-[3vh] bg-pink-500/50")], [content])
          4 -> div([class("w-[3vh] h-[3vh] bg-red-500/50")], [content])
          5 -> div([class("w-[3vh] h-[3vh] bg-cyan-500/50")], [content])
          6 -> div([class("w-[3vh] h-[3vh] bg-teal-500/50")], [content])
          7 -> div([class("w-[3vh] h-[3vh] bg-violet-500/50")], [content])
          8 -> div([class("w-[3vh] h-[3vh] bg-lime-500/50")], [content])
          9 -> div([class("w-[3vh] h-[3vh] bg-sky-500/50")], [content])
          _ -> div([class("w-[3vh] h-[3vh] bg-white/50")], [content])
        }
      })
    }),
  )
}
