import app/actors/actor_types.{type Action, type Player, Battle, Move}
import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{
  circle_x, dice_1, dice_2, dice_3, dice_4, dice_5, dice_6, footprints,
  info as info_icon, map, messages_square, shield, swords,
}
import app/pages/layout.{stats as info_stats}
import gleam/int
import gleam/list
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, style}
import lustre/element.{type Element}
import lustre/element/html.{button, div, li, p, text, ul}

pub fn roll_die(stats: Player) {
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
        die_section(stats.action),
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
        id("go_to_home"),
      ],
      [circle_x([])],
    ),
  ]
}

fn die_section(action: Action) {
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
      [roll_section(action)],
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
      [info_panel(action)],
    ),
  ])
}

fn dice() {
  [
    dice_1([class("w-56 h-56"), id("dice_anim")]),
    dice_2([class("w-56 h-56"), id("dice_anim")]),
    dice_3([class("w-56 h-56"), id("dice_anim")]),
    dice_4([class("w-56 h-56"), id("dice_anim")]),
    dice_5([class("w-56 h-56"), id("dice_anim")]),
    dice_6([class("w-56 h-56"), id("dice_anim")]),
  ]
  |> list.index_map(fn(svg, i) { #(i + 1, svg) })
}

pub fn anim_get_next_dice() {
  let assert Ok(die_to_show) =
    dice()
    |> list.shuffle()
    |> list.first()
  die_to_show.1 |> element.to_string
}

pub fn rolled_die(rolled: Int) {
  let assert Ok(die) = dice() |> list.find(fn(i_svg) { i_svg.0 == rolled })
  die.1
}

pub fn roll_section(action: Action) {
  let icon = case action {
    Move(_) -> footprints([class("!mr-[10px]")])
    Battle(_, 0, _, _) | Battle(_, _, 0, _) -> swords([class("!mr-[10px]")])
    _ -> shield([class("!mr-[10px]")])
  }
  let rolling_for = case action {
    Move(_) -> "movement"
    Battle(_, 0, _, _) -> "attack type"
    Battle(_, _, 0, _) -> "attack damage"
    Battle(_, x, y, _) if x < 4 && y < 4 -> "attack damage"
    _ -> "defence strategy"
  }
  let button_text = case action {
    Battle(_, _, _, 0) | Move(_) -> "Roll"
    _ -> "Hit!"
  }
  let rolled_value = case action {
    Move(0) -> 6
    Move(rolled) -> rolled
    Battle(_, notrolled, _, _) if notrolled == 0 -> 6
    Battle(_, rolled, 0, _) -> rolled
    Battle(_, _, rolled, 0) -> rolled
    Battle(_, _, _, rolled) -> rolled
  }
  div([class("")], [
    div([class("flex justify-center items-center")], [
      div(
        [
          class(
            "btn !bg-gray-100/60 !border !border-neutral-500 font-text !text-lg",
          ),
          style([#("cursor", "default")]),
        ],
        [icon, text("You are currently rolling for " <> rolling_for)],
      ),
    ]),
    div([class("flex justify-center items-center")], [rolled_die(rolled_value)]),
    div([class("flex justify-center items-center")], [
      button(
        [
          id("roll"),
          attribute("ws-send", ""),
          class(join(
            [
              "btn border font-text !text-xl", "bg-black/15 hover:bg-black/30",
              "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
              "border-black/40 text-current", "transition-all duration-500",
            ],
            " ",
          )),
        ],
        [text(button_text)],
      ),
    ]),
    dice_result(action),
  ])
}

pub fn dice_result(action: Action) {
  let content = case action {
    Move(rolled) -> [
      case rolled {
        0 -> p([class("font-text")], [text("You have not rolled yet")])
        _ ->
          p([class("font-text")], [
            text("To move (a max of) " <> int.to_string(rolled) <> " positions"),
          ])
      },
    ]
    Battle(_, a_type, damage, defence) -> {
      let attack_type = case a_type {
        0 -> []
        6 -> [p([class("font-text")], [text("Attack type: 6 (Critical hit)")])]
        x if x < 4 -> [
          p([class("font-text")], [
            text(
              "Attack type: "
              <> int.to_string(x)
              <> " (Light hits - chance to go twice!)",
            ),
          ]),
        ]
        x -> [
          p([class("font-text")], [text("Attack type: " <> int.to_string(x))]),
        ]
      }
      let a_damage = case damage {
        0 -> []
        x -> [
          p([class("font-text")], [text("Attack damage: " <> int.to_string(x))]),
        ]
      }
      let ds = case defence {
        0 -> []
        x -> [
          p([class("font-text")], [
            text("Defence strategy: " <> int.to_string(x)),
          ]),
        ]
      }
      let content = list.flatten([attack_type, a_damage, ds])
      case content |> list.length() {
        0 -> [p([class("font-text")], [text("You have not rolled yet")])]
        _ -> content
      }
    }
  }
  div([id("dice_result"), class("flex justify-center items-center")], [
    div(
      [
        class(
          "!mt-4 w-96 pl-4 py-4 rounded-xl !bg-gray-100/60 !border !border-neutral-500 font-text !text-lg",
        ),
        style([#("cursor", "default")]),
      ],
      content,
    ),
  ])
}

pub fn already_rolled() {
  button(
    [
      id("roll"),
      attribute("ws-send", ""),
      class(join(
        [
          "btn border font-text !text-red-500 !text-xl",
          "bg-black/15 hover:bg-black/30",
          "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
          "border-black/40 text-current", "transition-all duration-500",
        ],
        " ",
      )),
    ],
    [text("You have already rolled!")],
  )
  |> element.to_string
}

fn info_panel(action: Action) {
  let dice_type = case action {
    Move(_) -> "Movement"
    _ -> "Battle"
  }
  div(
    [
      class(
        "rounded-xl !bg-gray-100/60 !border !border-neutral-500 font-header !text-lg !mx-12",
      ),
      style([#("cursor", "default"), #("height", "50%")]),
    ],
    [
      info_icon([class("w-12 !pt-4 h-12"), style([#("margin", "0 auto")])]),
      p([class("text-center !my-4 text-3xl")], [
        text("The " <> dice_type <> " Dice"),
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
        case action {
          Move(_) -> [
            li([], [text("You will roll for positions you can move through")]),
            li([], [
              text(
                "Once you have rolled, you can go to the map and click on the position you wish to move to",
              ),
            ]),
            li([], [
              text("If the position is too far away, it will not be clickable"),
            ]),
            li([], [
              text(
                "If the position is closer than the maximum number of positions you can move through (the number you rolled), you will still use up the entire roll",
              ),
            ]),
            li([], [
              text(
                "You will only be allowed to move in straight lines, for your safety",
              ),
            ]),
          ]
          _ -> [
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
          ]
        },
      ),
    ],
  )
}
