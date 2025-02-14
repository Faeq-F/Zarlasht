import components/theme_switch.{theme_switch}
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, src, style}
import lustre/element.{fragment}
import lustre/element/html.{button, div, img, label, text}

pub fn bottom_bar() {
  fragment([
    html.div([attribute.id("BottomBar"), attribute("data-v-1139d4e0", "")], [
      html.div(
        [
          attribute.class(join(
            [
              "z-[999] absolute flex bottom-8 lg:bottom-10 rounded-full",
              "border !pl-2  min-h-10 inset-x-8 lg:inset-x-10 items-center justify-between pl-5 pr-5 lg:pr-2 py-2",
              "bg-black/10 border-black/15",
              "dark:bg-white/15 dark:border-white/15", "backdrop-blur-[6px]",
              "dark:shadow-[0px_10px_10px_-8px_rgba(18,18,23,0.02),0px_2px_2px_-1.5px_rgba(18,18,23,0.02),0px_1px_1px_-0.5px_rgba(18,18,23,0.02)]",
              "shadow-[0px_10px_10px_-8px_rgba(237,237,232,0.02),0px_2px_2px_-1.5px_rgba(237,237,232,0.02),0px_1px_1px_-0.5px_rgba(237,237,232,0.02)]",
              "transition-all duration-500",
            ],
            " ",
          )),
          attribute("data-v-1139d4e0", ""),
        ],
        [
          html.div(
            [
              attribute.class(
                "btn-group btn-group-rounded btn-group-scrollable",
              ),
            ],
            [
              theme_switch(),
              html.button(
                [
                  attribute.class(
                    "lg:inline-flex hidden items-center gap-2 pl-3 pr-4 py-2 rounded-full dark:bg-white/20 bg-black/15 dark:hover:bg-white/40 hover:bg-black/30 transition-all duration-500 border dark:border-white/40 border-black/40 text-current w-[45px] h-[40px] rounded-l-none",
                  ),
                ],
                [html.i([attribute.class("pi pi-spin pi-cog text-[20px]")], [])],
              ),
            ],
          ),
          html.div(
            [
              attribute.class(
                "btn-group btn-group-rounded btn-group-scrollable",
              ),
            ],
            [
              html.button(
                [
                  attribute.class(join(
                    [
                      "btn border lg:inline-flex",
                      "bg-black/15 hover:bg-black/30",
                      "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                      "border-black/40 text-current",
                      "transition-all duration-500",
                    ],
                    " ",
                  )),
                ],
                [html.text("Create a Game")],
              ),
              html.button(
                [
                  attribute.class(join(
                    [
                      "btn border lg:inline-flex",
                      "bg-black/15 hover:bg-black/30",
                      "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                      "border-black/40 text-current",
                      "transition-all duration-500",
                    ],
                    " ",
                  )),
                ],
                [html.text("Join a Game")],
              ),
            ],
          ),
          html.div([attribute.class("w-96 flex justify-end")], [
            html.div(
              [
                attribute.class(
                  "btn-group btn-group-rounded btn-group-scrollable",
                ),
              ],
              [
                html.button(
                  [
                    attribute.class(join(
                      [
                        "btn border lg:inline-flex",
                        "bg-black/15 hover:bg-black/30",
                        "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                        "border-black/40 text-current",
                        "transition-all duration-500",
                      ],
                      " ",
                    )),
                  ],
                  [html.text("Create a Game")],
                ),
                html.button(
                  [
                    attribute.class(join(
                      [
                        "btn border lg:inline-flex",
                        "bg-black/15 hover:bg-black/30",
                        "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                        "border-black/40 text-current",
                        "transition-all duration-500",
                      ],
                      " ",
                    )),
                  ],
                  [html.text("Join a Game")],
                ),
              ],
            ),
          ]),
        ],
      ),
    ]),
  ])
}
