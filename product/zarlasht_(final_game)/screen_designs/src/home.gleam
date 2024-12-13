import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn home() -> Element(t) {
  html.div([attribute.id("app")], [
    html.div(
      [attribute.class("hero bg-base-100 min-h-full"), attribute.id("page")],
      [
        html.div(
          [
            attribute.class(
              "hero-content text-left absolute top-1/2 -translate-y-1/2 w-full",
            ),
          ],
          [
            html.div([attribute.class("w-full")], [
              html.h1(
                [attribute.class("text-9xl font-bold mb-3 font-header ")],
                [html.text("Zarlasht")],
              ),
              html.div([attribute.class("w-full join")], [
                html.button(
                  [
                    attribute.class(
                      "text-2xl dark:hover:text-shadow join-item dark:text-slate-400 text-zinc-700 hover:text-secondary py-2 px-6 duration-700 font-bold bg-[#ffffff44] dark:bg-[#00000044]  border-r border-t border-b border-gray-600 rounded-lg bg-gradient-to-r from-transparent via-[#ffffff44] to-transparent",
                    ),
                  ],
                  [
                    html.text(
                      "Create a game
            ",
                    ),
                  ],
                ),
                html.button(
                  [
                    attribute.class(
                      "text-2xl dark:hover:text-shadow join-item dark:text-slate-400 text-zinc-700 hover:text-secondary py-2 px-6 duration-700 font-bold  dark:bg-[#00000044]  border-l border-t border-b border-gray-600 rounded-lg bg-gradient-to-r from-transparent via-[#ffffff44] to-transparent",
                    ),
                  ],
                  [
                    html.text(
                      "Join a game
            ",
                    ),
                  ],
                ),
              ]),
            ]),
          ],
        ),
      ],
    ),
  ])
}
