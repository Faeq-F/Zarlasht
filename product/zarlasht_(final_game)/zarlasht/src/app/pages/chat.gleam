import app/actors/actor_types.{
  type GameActorState, type Player, type PlayerSocket, GameState, GetState,
}
import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{
  circle_x, dices, map, send_horizontal, users_round,
}
import app/pages/layout.{stats as info_stats}
import gleam/dict
import gleam/erlang/process
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, name, role, style, type_}
import lustre/element.{type Element}
import lustre/element/html.{br, button, div, h1, label, p, span, text, textarea}

pub fn chat(player: PlayerSocket) {
  let assert Some(game_subject) = player.state.game_subject
  let assert GameState(game_state) =
    process.call_forever(game_subject, GetState)
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
          bottom_bar(info(player, game_state), buttons()),
        ]),
        chat_section(player.state.player.number, player, game_state),
      ],
    ),
  ])
  |> element.to_string
}

fn participants_to_chat_to(player: PlayerSocket, game_state: GameActorState) {
  game_state.participants
  |> list.filter(fn(participant) {
    { participant.0 }.number != player.state.player.number
  })
  |> list.map(fn(participant) {
    button(
      [
        class("btn w-full flex"),
        id("switch_chat_" <> int.to_string({ participant.0 }.number)),
        attribute("ws-send", ""),
      ],
      [
        div(
          [
            class(
              "flex-1 text-center font-text pl-2 text-"
              <> { participant.0 }.color
              <> "-500",
            ),
          ],
          [text({ participant.0 }.name)],
        ),
      ],
    )
  })
}

fn info(player: PlayerSocket, game_state: GameActorState) {
  div([class("flex")], [
    div(
      [
        class("btn !bg-gray-100 font-header !text-lg"),
        style([#("cursor", "default")]),
      ],
      [info_stats(player.state.player)],
    ),
    div(
      [
        class("btn-group  btn-group-scrollable !ml-[10px]"),
        style([#("height", "2.5rem")]),
      ],
      [
        div([class("popover popover-hover contents")], [
          label(
            [
              class(join(
                [
                  "popover-trigger btn border !rounded-r-none",
                  "bg-black/15 hover:bg-black/30",
                  "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                  "border-black/40 text-current", "transition-all duration-500",
                ],
                " ",
              )),
            ],
            [users_round([])],
          ),
          div(
            [
              class("popover-content w-32 popover-top-left !ml-26  !fixed"),
              style([#("width", "fit-content")]),
            ],
            [
              div([class("popover-arrow")], []),
              div([], [
                div(
                  [
                    class(
                      "btn-group btn-group-vertical btn-group-scrollable w-full max-w-full",
                    ),
                  ],
                  participants_to_chat_to(player, game_state),
                ),
              ]),
            ],
          ),
        ]),
        button(
          [
            class(join(
              [
                "btn border font-text !text-xl lg:inline-flex ",
                "bg-black/15 hover:bg-black/30",
                "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                "border-black/40 text-current", "transition-all duration-500",
              ],
              " ",
            )),
            id("switch_chat_" <> int.to_string(player.state.player.number)),
            attribute("ws-send", ""),
          ],
          [text("Allies")],
        ),
      ],
    ),
  ])
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
        id("go_to_map"),
      ],
      [map([])],
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

fn header(chat: String) {
  div([id("Header")], [
    h1([class("font-subheader !text-4xl text-center !mt-8")], [text(chat)]),
  ])
}

pub fn chat_section(
  to_chat_to: Int,
  player: PlayerSocket,
  game_state: GameActorState,
) {
  //if we get our own number to chat to, we should chat to our allies
  //else chat to a specific person
  let header_text = case to_chat_to == player.state.player.number {
    True -> "Allies"
    _ -> {
      let assert Ok(player_to_chat_to) =
        game_state.participants
        |> list.find(fn(participant) { { participant.0 }.number == to_chat_to })
      { player_to_chat_to.0 }.name
    }
  }
  div(
    [
      class(
        "relative flex flex-grow flex-col px-12 justify-end Chat overflowy-scroll",
      ),
      style([#("height", "calc(100% - 4.5rem)")]),
      id("chat_section"),
    ],
    [
      header(header_text),
      div(
        [
          class(
            "mx-12 py-1 px-2 overflow-y-scroll overflow-x-hidden max-h-[80vh] h-full mt-10 !border rounded-box !border-neutral-500  rounded-xl",
          ),
        ],
        messages(to_chat_to, player, game_state),
      ),
      send_message_section(to_chat_to),
    ],
  )
}

fn format_message(message: String) {
  list.intersperse(
    list.map(string.split(string.trim_end(message), "\n"), fn(x) { text(x) }),
    br([]),
  )
}

fn message_left(
  message: String,
  author: String,
  author_color: String,
  time: String,
) {
  div(
    [
      class(
        "font-text rounded-lg rounded-tl-none my-1 p-2 text-sm flex flex-col relative max-w-[80vw] bg-white/70 speech-bubble-left",
      ),
      style([#("width", "fit-content"), #("margin", "0.5rem auto 0 10px")]),
    ],
    [
      p([], format_message(message)),
      p([class("text-gray-600 text-xs text-right leading-none")], [
        span([class("font-subheader !mr-2 " <> author_color)], [text(author)]),
        text(time),
      ]),
    ],
  )
}

fn message_right(
  message: String,
  author: String,
  author_color: String,
  time: String,
) {
  div(
    [
      class(
        "font-text rounded-lg rounded-tr-none my-1 p-2 text-sm flex flex-col relative max-w-[80vw] bg-white/70 speech-bubble-right",
      ),
      style([#("width", "fit-content"), #("margin", "0.5rem 10px 0 auto")]),
    ],
    [
      p([], format_message(message)),
      p([class("text-gray-600 text-xs text-right leading-none")], [
        text(time),
        span([class("font-subheader !ml-2 " <> author_color)], [text(author)]),
      ]),
    ],
  )
}

fn send_message_section(to_chat_to: Int) {
  div(
    [
      class(
        "!mt-2 !h-[15%] flex w-full flex-col overflow-hidden border-neutral-300 bg-white/50 text-neutral-600 has-[p:focus]:outline-2 has-[p:focus]:outline-offset-2 has-[p:focus]:outline-black dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300 dark:has-[p:focus]:outline-white rounded-xl !border !border-neutral-500 ",
      ),
    ],
    [
      div([class("p-2")], [
        p(
          [
            class(
              "pb-1 pl-2 text-sm font-text font-bold text-neutral-600 opacity-60 dark:text-neutral-300",
            ),
            id("promptLabel"),
          ],
          [text("Enter your message below")],
        ),
        html.form(
          [
            attribute("ws-send", ""),
            id("send_message_" <> int.to_string(to_chat_to)),
          ],
          [
            textarea(
              [
                name("messageText"),
                class(
                  "font-text scroll-on max-h-8 h-8 w-full overflow-y-auto px-2 py-1 !outline-none resize-none",
                ),
              ],
              "",
            ),
            button(
              [
                class(
                  "font-text h-[2rem] !mr-1 text-white !ml-auto flex items-center gap-2 whitespace-nowrap hover:bg-black bg-black/80 !px-4 !py-2 text-center !text-sm font-medium tracking-wide text-neutral-100 transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75 dark:bg-white dark:text-black dark:focus-visible:outline-white rounded-lg",
                ),
              ],
              [text("Send"), send_horizontal([class("w-4")])],
            ),
          ],
        ),
      ]),
    ],
  )
}

fn messages(to_chat_to: Int, player: PlayerSocket, game_state: GameActorState) {
  let messages = case to_chat_to == player.state.player.number {
    True -> {
      //if we get our own number to chat to, we should chat to our allies
      let assert Ok(key) =
        game_state.ally_chats
        |> dict.keys()
        |> list.find(fn(key) { key |> list.contains(to_chat_to) })
      let assert Ok(messages) = game_state.ally_chats |> dict.get(key)
      messages
    }
    _ -> {
      //else chat to a specific person
      let assert Ok(key) =
        game_state.player_chats
        |> dict.keys()
        |> list.find(fn(key) {
          { key.0 == to_chat_to && key.1 == player.state.player.number }
          || { key.0 == player.state.player.number && key.1 == to_chat_to }
        })
      let assert Ok(messages) = game_state.player_chats |> dict.get(key)
      messages
    }
  }

  messages
  |> list.map(fn(message) {
    case message.sender == to_chat_to {
      True -> {
        message_right(
          message.message,
          message.name,
          "text-" <> message.color <> "-500",
          message.time,
        )
      }
      _ -> {
        message_left(
          message.message,
          message.name,
          "text-" <> message.color <> "-500",
          message.time,
        )
      }
    }
  })
}
