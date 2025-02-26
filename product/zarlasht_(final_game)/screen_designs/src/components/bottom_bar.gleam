import components/information_modal.{info_modal}
import components/leaderboard.{leaderboard}
import components/theme_switch.{theme_switch}
import gleam/string.{join}
import lustre/attribute.{class, id, style}
import lustre/element.{fragment}
import lustre/element/html.{div}

pub fn bottom_bar(info, buttons) {
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
              leaderboard(),
            ]),
            info,
            div([class("w-96 flex justify-end")], [
              div(
                [
                  class("btn-group  btn-group-scrollable"),
                  style([#("height", "2.5rem")]),
                ],
                buttons,
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}
