import app/actors/actor_types
import gleam/int
import gleam/list
import gleam/string
import lucide_lustre.{circle, rotate_cw, x}
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html.{text}
import lustre/element/svg

pub fn game_page() -> String {
  html.div(
    [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
    [
      html.h1([attribute.class("text-5xl font-bold mt-4")], [
        element.text("Tic-Tac-Toe"),
      ]),
      html.div(
        [
          attribute.class(
            "divider lg:divider-horizontal absolute top-1/2 -translate-y-1/2 h-96",
          ),
        ],
        [],
      ),
      html.div(
        [
          attribute.class(
            "hero-content text-center absolute top-1/2 -translate-y-1/2 min-w-full h-screen pt-16 pb-12",
          ),
        ],
        [
          html.div(
            [
              attribute.class(
                "grid lg:grid-cols-2 grid-cols-1 gap-10 w-full h-full",
              ),
            ],
            [
              html.div([attribute.class("card text-center h-full")], [
                html.div(
                  [
                    attribute.class("w-4/6 h-1/7 rounded-3xl p-4"),
                    attribute.id("player1"),
                  ],
                  [],
                ),
                html.div(
                  [
                    attribute.class(
                      "m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full",
                    ),
                    attribute.id("game"),
                  ],
                  [],
                ),
                html.div(
                  [
                    attribute.class("w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-auto"),
                    attribute.id("player2"),
                  ],
                  [],
                ),
              ]),
              html.div(
                [
                  attribute.class(
                    "card text-center h-screen lg:h-full mt-32 lg:mt-0",
                  ),
                ],
                [
                  html.div(
                    [
                      attribute.class(
                        "w-4/6 max-h-[85vh] h-screen overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4",
                      ),
                      attribute.id("chat"),
                      attribute("hx-swap-oob", "beforeend"),
                    ],
                    [
                      html.h1([attribute.class("text-2xl font-bold mt-4")], [
                        element.text("Chat"),
                      ]),
                    ],
                  ),
                  send_message_form(),
                  html.script(
                    [],
                    "
                  document.getElementById(\"message_textarea\")
                  .addEventListener(\"keydown\", (evt) => {
                    if (evt.keyCode == 13 && !evt.shiftKey){
                      evt.preventDefault();
                      document.getElementById(\"send_message\").click();
                  }});
                  ",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      html.div([attribute.id("status")], []),
    ],
  )
  |> element.to_string
}

pub fn update_status(
  turn: Bool,
  player_viewed: actor_types.Player,
  player_won: String,
) -> String {
  html.div(
    [
      attribute.id("status"),
      attribute.class("max-w-md text-center absolute bottom-0 lg:mb-36 mb-16"),
    ],
    case player_won {
      "Neither" -> {
        case turn {
          True -> [
            html.p([attribute.class("text-xl text-info")], [
              html.text("Your turn"),
            ]),
          ]
          _ -> [
            html.p([attribute.class("text-xl text-warning")], [
              html.text("Their turn"),
            ]),
          ]
        }
      }
      _ -> {
        case player_won == "Draw" {
          True -> [
            html.p([attribute.class("text-xl text-orange-400")], [
              html.text("Draw!"),
            ]),
            html.button(
              [
                attribute.id("replay_button"),
                attribute("hx-ext", "ws"),
                attribute("ws-send", ""),
              ],
              [
                html.text("Replay"),
                rotate_cw([class("ml-1.5 w-3.5 h-3.5 inline")]),
              ],
            ),
          ]
          _ -> {
            case
              {
                case player_won {
                  "X" -> actor_types.X
                  _ -> actor_types.O
                }
              }
              == player_viewed
            {
              True -> [
                html.p([attribute.class("text-xl text-secondary")], [
                  html.text("You Won!"),
                ]),
                html.button(
                  [
                    attribute.id("replay_button"),
                    attribute("hx-ext", "ws"),
                    attribute("ws-send", ""),
                  ],
                  [
                    html.text("Replay"),
                    rotate_cw([class("ml-1.5 w-3.5 h-3.5 inline")]),
                  ],
                ),
              ]

              _ -> [
                html.p([attribute.class("text-xl text-error")], [
                  html.text("You Lost!"),
                ]),
                html.button(
                  [
                    attribute.id("replay_button"),
                    attribute("hx-ext", "ws"),
                    attribute("ws-send", ""),
                  ],
                  [
                    html.text("Replay"),
                    rotate_cw([class("ml-1.5 w-3.5 h-3.5 inline")]),
                  ],
                ),
              ]
            }
          }
        }
      }
    },
  )
  |> element.to_string
}

pub fn game_grid(
  game_state: actor_types.GameState,
  player_viewed: actor_types.Player,
  turn: Bool,
) -> String {
  html.div(
    [
      attribute.class(
        "m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full",
      ),
      attribute.id("game"),
    ],
    generate_boxes([], 0, game_state, player_viewed, turn),
  )
  |> element.to_string
}

fn generate_boxes(
  boxes: List(Element(button)),
  current_index: Int,
  game_state: actor_types.GameState,
  player_viewed: actor_types.Player,
  turn: Bool,
) -> List(Element(button)) {
  case current_index == 9 {
    True -> boxes
    _ -> {
      generate_boxes(
        list.append(boxes, [
          game_box(
            current_index |> int.to_string,
            get_player_from_game_state(game_state, current_index),
            player_viewed,
            turn,
          ),
        ]),
        current_index + 1,
        game_state,
        player_viewed,
        turn,
      )
    }
  }
}

fn get_player_from_game_state(
  game_state: actor_types.GameState,
  current_index: Int,
) -> actor_types.Player {
  let assert Ok(occupier) =
    list.first(list.split(game_state.state, current_index).1)
  occupier
}

fn game_box(
  id: String,
  player_filled: actor_types.Player,
  player_viewed: actor_types.Player,
  turn: Bool,
) -> Element(button) {
  let border_style =
    string.concat([
      "border-2 rounded-3xl ",
      case player_viewed == player_filled {
        True -> "border-primary"
        _ -> {
          case player_filled == actor_types.Neither {
            True -> "border-gray-200"
            _ -> "border-accent"
          }
        }
      },
    ])
  case player_filled {
    actor_types.X -> {
      html.button(
        [
          attribute.id(id),
          attribute.class(border_style),
          attribute("hx-ext", "ws"),
          attribute("ws-send", ""),
          attribute.disabled(True),
        ],
        [x([class("w-36 h-36 inline")])],
      )
    }
    actor_types.O -> {
      html.button(
        [
          attribute.id(id),
          attribute.class(border_style),
          attribute("hx-ext", "ws"),
          attribute("ws-send", ""),
          attribute.disabled(True),
        ],
        [circle([class("inline lg:w-24 lg:h-24 w-full h-full")])],
      )
    }
    _ -> {
      html.button(
        [
          attribute.id(id),
          attribute.class(border_style),
          attribute("hx-ext", "ws"),
          attribute("ws-send", ""),
          attribute.disabled(!turn),
        ],
        [empty("w-36 h-36 inline fill-current")],
      )
    }
  }
}

pub fn message(message: String, me: Bool) -> String {
  html.div(
    [
      attribute.class(
        "w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4",
      ),
      attribute.id("chat"),
      attribute("hx-swap-oob", "beforeend"),
    ],
    [
      case me {
        True -> {
          html.div([attribute.class("chat chat-end")], [
            html.div(
              [
                attribute.class(
                  "chat-bubble whitespace-pre-wrap text-left bg-secondary text-secondary-content",
                ),
              ],
              [text(message)],
            ),
          ])
        }
        _ -> {
          html.div([attribute.class("chat chat-start")], [
            html.div(
              [
                attribute.class(
                  "chat-bubble whitespace-pre-wrap text-left bg-accent text-secondary-content",
                ),
              ],
              [text(message)],
            ),
          ])
        }
      },
    ],
  )
  |> element.to_string
}

pub fn send_message_form() -> Element(form) {
  html.form(
    [
      attribute.id("send_message_form"),
      attribute.class("my-2 mx-auto w-4/6"),
      attribute("ws-send", ""),
    ],
    [
      html.div([attribute.class("join w-full border-gray-200 border-2 ")], [
        html.textarea(
          [
            attribute.id("message_textarea"),
            attribute.name("message"),
            attribute.placeholder("Send a message"),
            attribute("style", "height: 17px;"),
            attribute.class("w-full textarea textarea-bordered join-item"),
          ],
          "",
        ),
        html.button(
          [
            attribute.class(
              "btn bg-secondary hover:bg-accent join-item text-secondary-content",
            ),
            attribute.id("send_message"),
          ],
          [text("Send")],
        ),
      ]),
    ],
  )
}

pub fn player(player: actor_types.Player, name: String) -> String {
  case player {
    actor_types.X -> {
      html.div(
        [
          attribute.class("w-4/6 h-1/7 rounded-3xl p-4 pl-36 text-left"),
          attribute.id("player1"),
        ],
        [
          x([class("w-10 h-10 inline ")]),
          html.p([attribute.class("inline text-lg")], [text(name)]),
        ],
      )
      |> element.to_string
    }
    _ -> {
      html.div(
        [
          attribute.class(
            "w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-auto pr-36 text-right",
          ),
          attribute.id("player2"),
        ],
        [
          html.p([attribute.class("inline text-lg")], [text(name)]),
          circle([class("inline w-8 h-8  ml-1")]),
        ],
      )
      |> element.to_string
    }
  }
}

pub fn empty(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute.class(classes),
      attribute("x", "0px"),
      attribute("y", "0px"),
      attribute("width", "100"),
      attribute("height", "100"),
      attribute("viewBox", "0 0 72 72"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
    ],
    [],
  )
}
