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
            html.tbody([], [
              html.tr([], [
                html.th([], [trophy([]), html.text("1st")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [
                  html.text("John"),
                  html.div([attribute.class("badge badge-accent ml-2")], [
                    html.text("Winner"),
                  ]),
                ]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [medal([]), html.text("2nd")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [medal([]), html.text("3rd")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("4th")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("trophy")]),
                html.td([], [html.text("Faeq")]),
                html.td([], [html.text("John <inline medal>")]),
                html.td([], [html.text("18 - 12")]),
                html.td([], [html.text("6")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
                html.td([], [html.text("Purple")]),
              ]),
            ]),
          ]),
        ],
      ),
    ],
  )
  |> element.to_string
}
