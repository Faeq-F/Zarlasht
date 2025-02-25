import components/information_modal.{info_modal}
import components/lucide_lustre.{copy, github, info}
import components/theme_switch.{theme_switch}
import gleam/string.{join}
import lustre/attribute.{
  attribute, class, href, id, rel, src, style, target, type_,
}
import lustre/element.{fragment}
import lustre/element/html.{a, br, button, div, img, label, p, text}
import lustre/element/svg

pub fn bottom_bar(screen) {
  fragment([
    div(
      [
        id("BottomBar"),
        class("!fixed !bottom-[1.5rem]"),
        style([#("width", "calc(100% - 2rem)")]),
      ],
      [
        div(
          [
            class(join(
              [
                "!flex !rounded-full !ml-[0.5rem] !mr-[0.5rem]",
                "!items-center !justify-between !py-2 !px-2",
                "!bg-black/10 !border !border-black/15",
                "!dark:bg-white/15 !dark:border-white/15",
                "!backdrop-blur-[6px]",
                "!dark:shadow-[0px_10px_10px_-8px_rgba(18,18,23,0.02),0px_2px_2px_-1.5px_rgba(18,18,23,0.02),0px_1px_1px_-0.5px_rgba(18,18,23,0.02)]",
                "!shadow-[0px_10px_10px_-8px_rgba(237,237,232,0.02),0px_2px_2px_-1.5px_rgba(237,237,232,0.02),0px_1px_1px_-0.5px_rgba(237,237,232,0.02)]",
                "!transition-all !duration-500",
              ],
              " ",
            )),
          ],
          [
            div([class("w-96 flex justify-start")], [
              theme_switch(),
              info_modal(),
            ]),
            case screen {
              "home" -> home_info()
              "created_game" -> created_game_info()
              _ -> fragment([])
            },
            div([class("w-96 flex justify-end")], [
              div([class("btn-group  btn-group-scrollable")], case screen {
                "home" -> home_buttons()
                "created_game" -> created_game_buttons(3978)
                _ -> []
              }),
            ]),
          ],
        ),
      ],
    ),
  ])
}

fn home_buttons() {
  [
    button(
      [
        class(join(
          [
            "btn border lg:inline-flex", "bg-black/15 hover:bg-black/30",
            "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
            "border-black/40 text-current", "transition-all duration-500",
          ],
          " ",
        )),
      ],
      [text("Create a Game")],
    ),
    button(
      [
        class(join(
          [
            "btn border lg:inline-flex !rounded-full !rounded-l-none",
            "bg-black/15 hover:bg-black/30",
            "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
            "border-black/40 text-current", "transition-all duration-500",
          ],
          " ",
        )),
      ],
      [text("Join a Game")],
    ),
  ]
}

fn created_game_buttons(game_code) {
  [
    button(
      [
        class(
          "btn whitespace-nowrap rounded-sm bg-green-500 px-4 py-2 text-center text-sm font-medium tracking-wide text-white transition hover:opacity-75 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-500 active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75",
        ),
        type_("button"),
        attribute(
          "x-on:click",
          "$dispatch('notify', { variant: 'success', title: 'Success!',  message: 'Your changes have been saved. Keep up the great work!' })",
        ),
      ],
      [copy([])],
    ),
    button([class(join(["btn !rounded-r-full"], " "))], [text("Start Game")]),
  ]
}

fn home_info() {
  div([class("btn !bg-gray-100 font-header")], [text("Zarlasht")])
}

fn created_game_info() {
  div([class("btn !bg-gray-100")], [text("minimum of 5 players")])
}
