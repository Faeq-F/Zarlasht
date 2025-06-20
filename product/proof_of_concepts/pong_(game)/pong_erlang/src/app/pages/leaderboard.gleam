//// The leaderboard for the game

import app/actors/actor_types.{
  type LeaderboardInformation, LeaderboardInformation,
}
import gleam/int.{to_string}
import gleam/list.{sort}
import gleam/order.{type Order}
import gleam/yielder.{from_list, index, map, to_list}
import lucide_lustre.{medal, trophy, x}
import lustre/attribute
import lustre/element
import lustre/element/html

///The leaderboard for all games
///
pub fn leaderboard(information: List(LeaderboardInformation)) {
  html.div(
    [
      attribute.id("overlay"),
      attribute.class(
        "w-screen h-screen absolute bg-base-100 z-[999] left-0 top-0",
      ),
    ],
    [
      html.label(
        [
          attribute.class("right-0 m-4 fixed z-10 bottom-0 cursor-pointer"),
          attribute.id("Xleaderboard"),
          attribute.attribute("ws-send", ""),
        ],
        [x([])],
      ),
      html.div(
        [
          attribute.class(
            "overflow-x-auto absolute w-screen rounded-lg text-3xl text-center top-6",
          ),
        ],
        [html.text("Leaderboard")],
      ),
      html.div(
        [
          attribute.class(
            "overflow-x-auto h-[90vh] absolute w-[90vw] left-1/2 -translate-x-1/2 border border-current rounded-2xl bottom-3",
          ),
        ],
        [
          html.table([attribute.class("table table-pin-rows table-pin-cols")], [
            html.thead([], [
              html.tr([attribute.class("border-current")], [
                html.th([], []),
                html.th([], [html.text("Player 1")]),
                html.th([], [html.text("Player 2")]),
                html.th([], [html.text("Score")]),
                //Matches are sorted by least difference
                html.th([], [html.text("Difference")]),
              ]),
            ]),
            html.tbody([], table_rows(information)),
          ]),
        ],
      ),
    ],
  )
  |> element.to_string
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
  let difference1 =
    int.max(information1.player1score, information1.player2score)
    - int.min(information1.player1score, information1.player2score)

  let difference2 =
    int.max(information2.player1score, information2.player2score)
    - int.min(information2.player1score, information2.player2score)

  case difference1 == difference2 {
    True -> order.Eq
    _ -> {
      // want the lower difference to be first
      case difference1 > difference2 {
        True -> order.Gt
        _ -> order.Lt
      }
    }
  }
}

///A row on the leaderboard
///
fn create_row(information: LeaderboardInformation, index: Int) {
  let index = index + 1
  html.tr([attribute.class("border-current")], [
    html.th([], [prize(index), html.text(nth_number(index))]),
    html.td([], [
      html.text(information.player1name),
      winner_badge(information, True),
    ]),
    html.td([], [
      html.text(information.player2name),
      winner_badge(information, False),
    ]),
    html.td([], [
      html.text(
        to_string(information.player1score)
        <> " - "
        <> to_string(information.player2score),
      ),
    ]),
    html.td([], [
      html.text(to_string(
        int.max(information.player1score, information.player2score)
        - int.min(information.player1score, information.player2score),
      )),
    ]),
  ])
}

///The badge to indicate if a player won the game they played
///
fn winner_badge(information: LeaderboardInformation, player1: Bool) {
  case
    int.max(information.player1score, information.player2score)
    == information.player1score
  {
    True -> {
      //player 1 won
      case player1 {
        True ->
          html.div([attribute.class("badge badge-accent ml-2")], [
            html.text("Winner"),
          ])
        _ -> element.none()
      }
    }
    _ -> {
      //player 2 won
      case player1 {
        True -> element.none()
        _ ->
          html.div([attribute.class("badge badge-accent ml-2")], [
            html.text("Winner"),
          ])
      }
    }
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
