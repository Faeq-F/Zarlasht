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

pub fn leaderboard() {
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
              html.tr([], [
                html.th([], []),
                html.th([], [html.text("Player 1")]),
                html.th([], [html.text("Player 2")]),
                html.th([], [html.text("Score")]),
                //Matches are sorted by least difference
                html.th([], [html.text("Difference")]),
              ]),
            ]),
            html.tbody([], table_rows()),
          ]),
        ],
      ),
    ],
  )
  |> element.to_string
}

fn table_rows() {
  sort(
    [
      LeaderboardInformation(
        player1name: "Faeq",
        player2name: "John",
        player1score: 3,
        player2score: 8,
      ),
      LeaderboardInformation(
        player1name: "Hi",
        player2name: "k",
        player1score: 8,
        player2score: 3,
      ),
      LeaderboardInformation(
        player1name: "Hi",
        player2name: "k",
        player1score: 8,
        player2score: 3,
      ),
      LeaderboardInformation(
        player1name: "Person 1",
        player2name: "Person 2",
        player1score: 5,
        player2score: 6,
      ),
      LeaderboardInformation(
        player1name: "Person 1",
        player2name: "Person 2",
        player1score: 5,
        player2score: 6,
      ),
      LeaderboardInformation(
        player1name: "Person 1",
        player2name: "Person 2",
        player1score: 5,
        player2score: 6,
      ),
    ],
    compare_leaderboard_information,
  )
  |> from_list
  |> index
  |> map(fn(information) { create_row(information.0, information.1) })
  |> to_list
}

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

fn create_row(information: LeaderboardInformation, index: Int) {
  let index = index + 1
  html.tr([], [
    html.th([], [prize(index), html.text(nth_number(index))]),
    html.td([], [
      html.text(information.player1name),
      winnder_badge(information, True),
    ]),
    html.td([], [
      html.text(information.player2name),
      winnder_badge(information, False),
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

fn winnder_badge(information: LeaderboardInformation, player1: Bool) {
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

fn prize(number: Int) {
  case number {
    1 -> trophy([])
    2 | 3 -> medal([])
    _ -> element.none()
  }
}
