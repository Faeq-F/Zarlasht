//// The home page when in a game (main game page)

import app/actors/actor_types.{type Player, Battle, EnemyTribe, Move}

import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{
  dices, footprints, info as info_icon, map, messages_square, radar, sword,
}

import app/pages/layout.{stats as info_stats}
import gleam/list
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, style}
import lustre/element
import lustre/element/html.{button, div, li, p, text, ul}

/// The main game page
///
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
        info_section(stats),
      ],
    ),
  ])
  |> element.to_string
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

/// The main section of the page that is divided into two
///
fn info_section(player: Player) {
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
      [area_panel(player.action)],
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
      [info_panel(player.updates)],
    ),
  ])
}

/// The section in the main section where the player is told where they are in the map and what they are doing
///
fn area_panel(action) {
  //TODO - rest of battle types
  let title = case action {
    Move(_) -> "Traversal"
    Battle(EnemyTribe(_), _, _, _) -> "Enemy Tribe!"
    _ -> "Ambush!"
  }
  let description = case action {
    Move(_) ->
      "You are trying to make your way around the mountain peak. Earlier, you heard of all sorts of nightmares that could be on the trail; you must choose your path wisely!"
    Battle(EnemyTribe(_), _, _, _) ->
      "You are on the border of the forest and a neighboring tribe spotted you. You are being ambushed and must fight your way out!"
    _ ->
      "You're carrying precious resources to get through the ritual. Food, water, weapons, ammunition. Enough for a neighboring tribe to try and plunder!"
  }
  let status = case action {
    Move(_) -> "The trail"
    _ -> "Battle"
  }
  let status_content = case action {
    Move(_) -> traversal_section()
    _ -> expert_swordsman_section()
  }
  div([class("")], [
    div([class("flex  items-center")], [
      div(
        [
          class("!ml-8 font-subheader items-end inline-flex !text-6xl"),
          style([#("cursor", "default")]),
        ],
        [radar([class("!w-18 !h-18 !mr-[10px]")]), text(title)],
      ),
    ]),
    div([class("flex justify-center items-center")], [
      div(
        [
          class("!ml-8 font-text !text-lg !text-left !my-6"),
          style([#("cursor", "default")]),
        ],
        [text(description)],
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
          p([class("text-center !my-4 text-3xl")], [text(status)]),
          status_content,
        ],
      ),
    ]),
  ])
}

/// The section to show in the area panel if the player is currently not in battle
///
fn traversal_section() {
  div([class("flex")], [
    div(
      [
        class("!inline"),
        style([
          #("width", "40%"),
          #("height", "50vh"),
          #("align-content", "center"),
          #("background-image", "url(/static/mountain.png)"),
          #("background-position", "center"),
          #("background-size", "contain"),
          #("background-repeat", "no-repeat"),
        ]),
      ],
      [],
    ),
    div(
      [
        class("!inline content-center"),
        style([#("width", "60%"), #("height", "50vh")]),
      ],
      [
        p([class("font-subheader inline-flex text-4xl")], [
          footprints([class("self-center !mr-1 w-8 h-8")]),
          text("Footprints"),
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
          [
            li([], [
              text("Beware of falling rocks, avalanches, and slippery ice."),
            ]),
            li([], [
              text(
                "Stay alert to changing weather that affects your visibility and movement.",
              ),
            ]),
            li([], [
              text(
                "Discover hidden paths, caves, and treasure on your way round.",
              ),
            ]),
            li([], [
              text(
                "Be selective of who you fight, build and save your strength for the final ritual.",
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}

/// The section to show in the area panel if the player is currently in battle
///
fn expert_swordsman_section() {
  div([class("flex")], [
    div(
      [
        class("!inline"),
        style([
          #("width", "40%"),
          #("height", "50vh"),
          #("align-content", "center"),
          #("background-image", "url(/static/expertSwordsman.png)"),
          #("background-position", "center"),
          #("background-size", "contain"),
          #("background-repeat", "no-repeat"),
        ]),
      ],
      [],
    ),
    div(
      [
        class("!inline content-center"),
        style([#("width", "60%"), #("height", "50vh")]),
      ],
      [
        p([class("font-subheader inline-flex text-4xl")], [
          sword([class("self-center !mr-1 w-8 h-8")]),
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
          [
            li([], [
              text(
                "The Expert Swordsman is a skilled warrior who has been trained in the art of combat since he was a child. He is a formidable opponent and will not go down easily.",
              ),
            ]),
            li([], [
              text(
                "If he is not defeated quickly, he will call for reinforcements",
              ),
            ]),
            li([], [
              text("If he is too strong, you can call for allies to help you"),
            ]),
          ],
        ),
        call_allies_btn(),
      ],
    ),
  ])
}

/// A button that allows the user to call their allies to help them in battle
///
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

/// The section in the main section that shows updates in the game as it progresses
///
fn info_panel(updates: List(String)) {
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
        updates
          |> list.map(fn(update) { li([], [text(update)]) }),
      ),
    ],
  )
}
