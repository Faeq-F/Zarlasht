//// The map page in the game

import app/actors/actor_types.{
  type Action, type GameActorState, type Player, type WebsocketActorState, Move,
}

import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{
  circle_user_round, circle_x, dices, messages_square, scan,
}

import app/pages/layout.{stats as info_stats}
import gleam/int
import gleam/list
import gleam/result
import gleam/string.{join}
import lustre/attribute.{type Attribute, attribute, class, id, style}
import lustre/element.{type Element}
import lustre/element/html.{button, div, h1, text}

/// The map page
///
pub fn map(player: WebsocketActorState, game_state: GameActorState) {
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
          bottom_bar(info(player.player), buttons()),
        ]),
        map_section(player, game_state),
      ],
    ),
  ])
  |> element.to_string
}

/// The header for the page
///
fn header(chat: String) {
  div([], [h1([class("font-header !text-4xl text-center !mt-8")], [text(chat)])])
}

/// The section that contains the map
///
fn map_section(player: WebsocketActorState, game_state: GameActorState) {
  let current_positions =
    game_state.participants
    |> list.map(fn(player) {
      #(
        { player.0 }.name,
        { player.0 }.position.0,
        { player.0 }.position.1,
        { player.0 }.color,
      )
    })
  let covered_positions =
    player.player.old_positions
    |> list.append([player.player.position])
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
        generate_grid(
          player.player.position,
          covered_positions,
          current_positions,
          player.player.action,
        ),
      ),
      key(),
    ],
  )
}

//TODO - tooltips for key

/// The key for the map
///
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

/// The information to show on the bottom bar
///
fn info(stats: Player) {
  div(
    [
      class("btn !bg-gray-100 font-header !text-lg"),
      style([#("cursor", "default")]),
    ],
    [info_stats(stats)],
  )
}

/// The buttons to show on the bottom bar
///
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

/// The function that generates the grid for the map
///
fn generate_grid(
  current_position: #(Int, Int),
  covered_positions: List(#(Int, Int)),
  current_player_positions: List(#(String, Int, Int, String)),
  action: Action,
) {
  let can_click_around = case action {
    Move(around) -> {
      around
    }
    _ -> 0
  }
  let can_click_on = can_click_on(current_position, can_click_around)
  let map_grid_to_show = map_grid_to_show(covered_positions)
  list.flatten(
    list.index_map(map_grid(), fn(x, i) {
      list.index_map(x, fn(y, j) {
        case map_grid_to_show |> list.contains(#(j, i)) {
          True -> {
            let clickable = case can_click_on |> list.contains(#(j, i)) {
              True -> [
                id(
                  "clickable_position_"
                  <> int.to_string(j)
                  <> "_"
                  <> int.to_string(i),
                ),
                attribute("ws-send", ""),
                style([#("cursor", "pointer")]),
              ]
              _ -> []
            }
            let player =
              list.filter(current_player_positions, fn(z) {
                z.1 == j && z.2 == i
              })
            let content = case list.length(player) {
              num_players if num_players > 1 -> {
                let user_names =
                  player
                  |> list.fold("", fn(old, player) { old <> "\n" <> player.0 })
                element.fragment([
                  circle_user_round([
                    class("peer w-[3vh] h-[3vh] stroke-[neutral-500/50]"),
                  ]),
                  div(
                    [
                      attribute.role("tooltip"),
                      attribute.class(
                        "pointer-events-none w-fit relative bottom-0 mb-2 left-1/2 -translate-x-1/2 z-10 flex w-64 flex-col gap-1 rounded-sm bg-white p-2.5 text-xs font-text opacity-0 transition-all ease-out peer-hover:opacity-100 peer-focus:opacity-100",
                      ),
                    ],
                    [text(user_names)],
                  ),
                ])
              }
              1 -> {
                let user_color =
                  result.unwrap(list.first(player), #("", 0, 0, "")).3
                let user_name =
                  result.unwrap(list.first(player), #("", 0, 0, "")).0
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
                    [text(user_name)],
                  ),
                ])
              }
              _ -> text("")
            }
            cell(y, clickable, content)
          }
          _ -> {
            //neutral color for unseen parts of the map
            div([class("w-[3vh] h-[3vh] bg-neutral-500/50")], [text("")])
          }
        }
      })
    }),
  )
}

/// The generator for a single cell in the grid for the map
///
fn cell(y: Int, clickable: List(Attribute(a)), content: Element(a)) {
  case y {
    1 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-amber-500/50")]]
          |> list.flatten,
        [content],
      )
    2 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-emerald-500/50")]]
          |> list.flatten,
        [content],
      )
    3 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-pink-500/50")]]
          |> list.flatten,
        [content],
      )
    4 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-red-500/50")]]
          |> list.flatten,
        [content],
      )
    5 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-cyan-500/50")]]
          |> list.flatten,
        [content],
      )
    6 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-teal-500/50")]]
          |> list.flatten,
        [content],
      )
    7 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-violet-500/50")]]
          |> list.flatten,
        [content],
      )
    8 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-lime-500/50")]]
          |> list.flatten,
        [content],
      )
    9 ->
      div(
        [clickable, [class("w-[3vh] h-[3vh] bg-sky-500/50")]]
          |> list.flatten,
        [content],
      )
    //can't click on this
    _ -> div([class("w-[3vh] h-[3vh] bg-white/50")], [content])
  }
}

/// generates a list of positions the user should be able to click on, to move to
///
fn can_click_on(current_position: #(Int, Int), can_click_around: Int) {
  let right =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 + i, current_position.1) })
  let left =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 - i, current_position.1) })
  let up =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0, current_position.1 - i) })
  let down =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 - i, current_position.1 + i) })

  let tl =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 - i, current_position.1 + i) })
  let tr =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 + i, current_position.1 + i) })
  let bl =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 - i, current_position.1 - i) })
  let br =
    list.range(0, can_click_around)
    |> list.map(fn(i) { #(current_position.0 + i, current_position.1 - i) })

  [right, left, up, down, tl, tr, bl, br] |> list.flatten
}

/// A list of positions that can be shown to the player (as they have travelled
/// there and can see that far)
///
fn map_grid_to_show(covered_positions: List(#(Int, Int))) {
  covered_positions
  |> list.map(fn(pos) {
    //got this wrong - pos.1+1 goes down 1 - no need to change
    let up_one = #(pos.0, pos.1 + 1)
    let up_two = #(pos.0, pos.1 + 2)
    let down_one = #(pos.0, pos.1 - 1)
    let down_two = #(pos.0, pos.1 - 2)
    let left_one = #(pos.0 - 1, pos.1)
    let left_two = #(pos.0 - 2, pos.1)
    let right_one = #(pos.0 + 1, pos.1)
    let right_two = #(pos.0 + 2, pos.1)
    let tl_diag_one = #(pos.0 - 1, pos.1 + 1)
    let tl_diag_two = #(pos.0 - 2, pos.1 + 2)
    let tr_diag_one = #(pos.0 + 1, pos.1 + 1)
    let tr_diag_two = #(pos.0 + 2, pos.1 + 2)
    let bl_diag_one = #(pos.0 - 1, pos.1 - 1)
    let bl_diag_two = #(pos.0 - 2, pos.1 - 2)
    let br_diag_one = #(pos.0 + 1, pos.1 - 1)
    let br_diag_two = #(pos.0 + 2, pos.1 - 2)
    let tl_diag_off_one = #(pos.0 - 1, pos.1 + 2)
    let tl_diag_off_two = #(pos.0 - 2, pos.1 + 1)
    let tr_diag_off_one = #(pos.0 + 1, pos.1 + 2)
    let tr_diag_off_two = #(pos.0 + 2, pos.1 + 1)
    let bl_diag_off_one = #(pos.0 - 1, pos.1 - 2)
    let bl_diag_off_two = #(pos.0 - 2, pos.1 - 1)
    let br_diag_off_one = #(pos.0 + 1, pos.1 - 2)
    let br_diag_off_two = #(pos.0 + 2, pos.1 - 1)
    [
      pos,
      up_one,
      up_two,
      down_one,
      down_two,
      left_one,
      left_two,
      right_one,
      right_two,
      tl_diag_one,
      tl_diag_two,
      tr_diag_one,
      tr_diag_two,
      bl_diag_one,
      bl_diag_two,
      br_diag_one,
      br_diag_two,
      tl_diag_off_one,
      tl_diag_off_two,
      tr_diag_off_one,
      tr_diag_off_two,
      bl_diag_off_one,
      bl_diag_off_two,
      br_diag_off_one,
      br_diag_off_two,
    ]
  })
  |> list.flatten
}

/// The map grid itself, encoded in the type of cells
///
pub fn map_grid() {
  [
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
}
