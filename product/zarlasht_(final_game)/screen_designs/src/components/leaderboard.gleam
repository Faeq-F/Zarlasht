import components/lucide_lustre.{medal, trophy}
import gleam/int.{to_string}
import gleam/list.{sort}
import gleam/order.{type Order}
import gleam/string
import gleam/yielder.{from_list, index, map, to_list}
import lustre/attribute.{attribute, class, style}
import lustre/element.{fragment}
import lustre/element/html.{label, p, text}
import lustre/element/svg

pub fn leaderboard() {
  fragment([
    html.div([attribute("x-data", "{modalIsOpen: false}")], [
      html.button(
        [
          attribute.class(
            "btn border rounded-full !rounded-l-none text-current transition-all duration-500",
          ),
          attribute.type_("button"),
          attribute("x-on:click", "modalIsOpen = true"),
        ],
        [trophy([])],
      ),
      html.div(
        [
          attribute("aria-labelledby", "InformationModal"),
          attribute("aria-modal", "true"),
          attribute.role("dialog"),
          attribute.class(
            "fixed inset-0 z-30 flex items-end justify-start bg-black/20 p-4 !pb-[7rem] backdrop-blur-md  lg:p-8 h-screen w-screen -left-[1.5rem] -top-[90vh]",
          ),
          attribute("x-on:click.self", "modalIsOpen = false"),
          attribute("x-on:keydown.esc.window", "modalIsOpen = false"),
          attribute("x-trap.inert.noscroll", "modalIsOpen"),
          attribute("x-transition.opacity.duration.200ms", ""),
          attribute("x-show", "modalIsOpen"),
          attribute("x-cloak", ""),
        ],
        [
          html.div(
            [
              attribute.class(
                "w-full h-full flex flex-col gap-4 overflow-hidden rounded-2xl border border-neutral-300 bg-white text-neutral-600 dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300",
              ),
              attribute("x-transition:enter-end", "opacity-100 translate-y-0"),
              attribute("x-transition:enter-start", "opacity-0 translate-y-8"),
              attribute(
                "x-transition:enter",
                "transition ease-out duration-200 delay-100 motion-reduce:transition-opacity",
              ),
              attribute("x-show", "modalIsOpen"),
            ],
            [
              html.div(
                [
                  attribute.class(
                    "flex items-center justify-between border-b border-neutral-300 bg-neutral-50/60 p-4 dark:border-neutral-700 dark:bg-neutral-950/20",
                  ),
                ],
                [
                  label([class("m-4 text-3xl font-subheader")], []),
                  label([class("m-4 text-3xl font-subheader")], [
                    p([], [text("Leaderboard")]),
                  ]),
                  html.button(
                    [
                      attribute("aria-label", "close modal"),
                      attribute("x-on:click", "modalIsOpen = false"),
                    ],
                    [
                      svg.svg(
                        [
                          attribute.class("w-5 h-5"),
                          attribute("stroke-width", "1.4"),
                          attribute("fill", "none"),
                          attribute("stroke", "currentColor"),
                          attribute("aria-hidden", "true"),
                          attribute("viewBox", "0 0 24 24"),
                          attribute("xmlns", "http://www.w3.org/2000/svg"),
                        ],
                        [
                          svg.path([
                            attribute("d", "M6 18L18 6M6 6l12 12"),
                            attribute("stroke-linejoin", "round"),
                            attribute("stroke-linecap", "round"),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              html.div([attribute.class("px-4 py-8 font-text")], [
                html.div(
                  [
                    attribute.class(
                      "overflow-x-auto h-[78vh] absolute left-[2.5rem] border border-current rounded-2xl top-22",
                    ),
                    style([#("width", "calc(100vw - 5rem)")]),
                  ],
                  [
                    html.table(
                      [
                        attribute.class(
                          "table table-pin-rows table-pin-cols text-xl",
                        ),
                      ],
                      [
                        html.thead([], [
                          html.tr([attribute.class("border-current")], [
                            html.th([], []),
                            html.th([class("!text-xl")], [html.text("Player")]),
                            html.th([class("!text-xl")], [html.text("Time")]),
                          ]),
                        ]),
                        html.tbody([], table_rows(leaderboard_information())),
                      ],
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ],
      ),
    ]),
  ])
}

fn leaderboard_information() {
  [
    LeaderboardInformation("Faeq", 2332),
    LeaderboardInformation("Mubz", 32_358),
    LeaderboardInformation("Mahid", 33_348),
    LeaderboardInformation("Dennis", 43_328),
    LeaderboardInformation("Hossam", 233_358),
    LeaderboardInformation("F2aeq", 2332),
    LeaderboardInformation("M2ubz", 32_358),
    LeaderboardInformation("M2ahid", 33_348),
    LeaderboardInformation("D2ennis", 43_328),
    LeaderboardInformation("H2ossam", 233_358),
    LeaderboardInformation("F3aeq", 2332),
    LeaderboardInformation("M3ubz", 32_358),
    LeaderboardInformation("M3ahid", 33_348),
    LeaderboardInformation("D3ennis", 43_328),
    LeaderboardInformation("H3ossam", 233_358),
    LeaderboardInformation("Faeq4", 2),
    LeaderboardInformation("Faeq5", 46),
    LeaderboardInformation("Faeq6", 455),
  ]
}

///All leaderboard rows
///
fn table_rows(information: List(LeaderboardInformation)) {
  sort(information, compare_leaderboard_information)
  |> from_list
  |> index
  |> map(fn(information) { create_row(information.0, information.1) })
  |> to_list
}

///Comparator used to sort the games played
///
fn compare_leaderboard_information(
  information1: LeaderboardInformation,
  information2: LeaderboardInformation,
) -> Order {
  int.compare(information1.time, information2.time)
}

///A row on the leaderboard
///
fn create_row(information: LeaderboardInformation, index: Int) {
  let index = index + 1
  //adding colons to the times
  let time =
    string.reverse(merge_time_graphemes(
      string.to_graphemes(string.reverse(to_string(information.time))),
      "",
    ))
  let time = case string.length(time) {
    8 -> time
    _ -> string.pad_start(time, 8, "00:")
  }
  let time = case string.starts_with(time, ":") {
    True -> string.drop_start(time, 1)
    False -> time
  }
  html.tr([attribute.class("border-current")], [
    html.th([class("!text-xl")], [prize(index), html.text(nth_number(index))]),
    html.td([class("!text-xl")], [html.text(information.player_name)]),
    html.td([class("!text-xl")], [html.text(time)]),
  ])
}

fn merge_time_graphemes(graphemes: List(String), result: String) {
  case graphemes {
    [first, second, ..rest] ->
      merge_time_graphemes(rest, result <> first <> second <> ":")
    [first] -> result <> first
    [] -> result
  }
}

///Adds a suffix to the leaderboard position
///
/// e.g., 1st, 2nd, 3rd, 4th, 5th, etc.
///
fn nth_number(number: Int) {
  let assert Ok(remainder) = int.modulo(number, 10)
  to_string(number)
  <> case remainder {
    1 -> "st"
    2 -> "nd"
    3 -> "rd"
    _ -> "th"
  }
}

///Determines whether the position requires a prize
///
/// If the position is 1st place, then a trophy is provided. For 2nd or 3rd, it is a medal
///
fn prize(number: Int) {
  case number {
    1 -> trophy([])
    2 | 3 -> medal([])
    _ -> element.none()
  }
}

///Information required for rows on the leaderboard
///
pub type LeaderboardInformation {
  ///Information required for rows on the leaderboard
  ///
  /// time is saved as a 6 digit int, e.g., 00:45:56 will be saved as 004556 -> 4556
  ///
  LeaderboardInformation(player_name: String, time: Int)
}
