import components/bottom_bar.{bottom_bar}
import components/lucide_lustre.{
  circle_x, dices, map, send_horizontal, users_round,
}
import gleam/string.{join}
import layout.{stats}
import lustre/attribute.{attribute, class, id, name, role, style, type_}
import lustre/element.{type Element}
import lustre/element/html.{button, div, h1, p, text, textarea}
import lustre/element/svg

fn info() {
  div(
    [
      class("btn !bg-gray-100 font-header !text-lg"),
      style([#("cursor", "default")]),
    ],
    [stats()],
  )
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
      ],
      [users_round([]), p([class("!ml-2")], [text("Allies")])],
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
      ],
      [circle_x([])],
    ),
  ]
}

//-------------------------------

fn chat_button() {
  html.div([attribute.class("Chat-Button")], [
    html.button(
      [
        attribute.class(
          "w-full  text-shadow drop-shadow-xl text-accent hover:text-secondary hover:fill-[oklch(var(--s))] fill-[oklch(var(--a))] border-t border-b border-gray-600 rounded-lg duration-600",
        ),
      ],
      [
        svg.svg(
          [
            attribute.class("size-6  h-12 w-full mt-6"),
            attribute("stroke", "currentColor"),
            attribute("stroke-width", "1.5"),
            attribute("viewBox", "0 0 24 24"),
            attribute("fill", "none"),
            attribute("xmlns", "http://www.w3.org/2000/svg"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M20.25 8.511c.884.284 1.5 1.128 1.5 2.097v4.286c0 1.136-.847 2.1-1.98 2.193-.34.027-.68.052-1.02.072v3.091l-3-3c-1.354 0-2.694-.055-4.02-.163a2.115 2.115 0 0 1-.825-.242m9.345-8.334a2.126 2.126 0 0 0-.476-.095 48.64 48.64 0 0 0-8.048 0c-1.131.094-1.976 1.057-1.976 2.192v4.286c0 .837.46 1.58 1.155 1.951m9.345-8.334V6.637c0-1.621-1.152-3.026-2.76-3.235A48.455 48.455 0 0 0 11.25 3c-2.115 0-4.198.137-6.24.402-1.608.209-2.76 1.614-2.76 3.235v6.226c0 1.621 1.152 3.026 2.76 3.235.577.075 1.157.14 1.74.194V21l4.155-4.155",
              ),
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
            ]),
          ],
        ),
        html.br([]),
        html.p([attribute.class("text-2xl")], [html.text("Chat")]),
      ],
    ),
  ])
}

fn close_button() {
  html.div([attribute.class("Close pt-4")], [
    html.button(
      [
        attribute.class(
          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-error hover:fill-[oklch(var(--er))] border-t border-b border-gray-600 rounded-lg w-full",
        ),
      ],
      [
        svg.svg(
          [
            attribute.class(
              " h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl size-6",
            ),
            attribute("stroke", "currentColor"),
            attribute("stroke-width", "1.5"),
            attribute("viewBox", "0 0 24 24"),
            attribute("fill", "none"),
            attribute("xmlns", "http://www.w3.org/2000/svg"),
          ],
          [
            svg.path([
              attribute("d", "M6 18 18 6M6 6l12 12"),
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
            ]),
          ],
        ),
        html.br([]),
        html.p([attribute.class("text-2xl")], [html.text("Close")]),
      ],
    ),
  ])
}

fn map_button() {
  html.div([attribute.class("Map pt-4")], [
    html.button(
      [
        attribute.class(
          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full",
        ),
      ],
      [
        svg.svg(
          [
            attribute.class(
              "size-6 h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl",
            ),
            attribute("stroke", "currentColor"),
            attribute("stroke-width", "1.5"),
            attribute("viewBox", "0 0 24 24"),
            attribute("fill", "none"),
            attribute("xmlns", "http://www.w3.org/2000/svg"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M9 6.75V15m6-6v8.25m.503 3.498 4.875-2.437c.381-.19.622-.58.622-1.006V4.82c0-.836-.88-1.38-1.628-1.006l-3.869 1.934c-.317.159-.69.159-1.006 0L9.503 3.252a1.125 1.125 0 0 0-1.006 0L3.622 5.689C3.24 5.88 3 6.27 3 6.695V19.18c0 .836.88 1.38 1.628 1.006l3.869-1.934c.317-.159.69-.159 1.006 0l4.994 2.497c.317.158.69.158 1.006 0Z",
              ),
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
            ]),
          ],
        ),
        html.br([]),
        html.p([attribute.class("text-2xl")], [html.text("Map")]),
      ],
    ),
  ])
}

fn roll_die_button() {
  html.div([attribute.class("Roll-die pt-4")], [
    html.button(
      [
        attribute.class(
          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full",
        ),
      ],
      [
        svg.svg(
          [
            attribute.class(
              "size-6 h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl",
            ),
            attribute("stroke", "currentColor"),
            attribute("stroke-width", "1.5"),
            attribute("viewBox", "0 0 24 24"),
            attribute("fill", "none"),
            attribute("xmlns", "http://www.w3.org/2000/svg"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M15.042 21.672 13.684 16.6m0 0-2.51 2.225.569-9.47 5.227 7.917-3.286-.672Zm-7.518-.267A8.25 8.25 0 1 1 20.25 10.5M8.288 14.212A5.25 5.25 0 1 1 17.25 10.5",
              ),
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
            ]),
          ],
        ),
        html.br([]),
        html.p([attribute.class("text-2xl")], [html.text("Roll die")]),
      ],
    ),
  ])
}

fn chat_section() {
  div(
    [
      class(
        "pt-20 relative flex flex-grow flex-col px-12 justify-end Chat overflowy-scroll",
      ),
      style([#("height", "calc(100% - 5.5rem)")]),
    ],
    [
      div(
        [
          class(
            "mx-12 py-1 px-2 overflow-y-scroll overflow-x-hidden max-h-[80vh] h-full mt-10 border rounded-box border-white !border-4 rounded-xl",
          ),
        ],
        messages(),
      ),
      message_section(),
    ],
  )
}

fn message_left(message: String, time: String) {
  div(
    [
      class(
        "rounded-lg rounded-tl-none my-1 p-2 text-sm flex flex-col relative max-w-[80vw] bg-white speech-bubble-left",
      ),
      style([#("width", "fit-content"), #("margin", "0 auto 0 10px")]),
    ],
    [
      p([], [text(message)]),
      p([class("text-gray-600 text-xs text-right leading-none")], [text(time)]),
    ],
  )
}

fn message_right(message: String, time: String) {
  div(
    [
      class(
        "rounded-lg rounded-tr-none my-1 p-2 text-sm flex flex-col relative max-w-[80vw] bg-white speech-bubble-right",
      ),
      style([#("width", "fit-content"), #("margin", "0 10px 0 auto")]),
    ],
    [
      p([], [text(message)]),
      p([class("text-gray-600 text-xs text-right leading-none")], [text(time)]),
    ],
  )
}

fn message_section() {
  div(
    [
      class(
        "!mt-2 !h-[15%] flex w-full flex-col overflow-hidden border-neutral-300 bg-neutral-50 text-neutral-600 has-[p:focus]:outline-2 has-[p:focus]:outline-offset-2 has-[p:focus]:outline-black dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300 dark:has-[p:focus]:outline-white rounded-xl border",
      ),
    ],
    [
      div([class("p-2")], [
        p(
          [
            class(
              "pb-1 pl-2 text-sm font-bold text-neutral-600 opacity-60 dark:text-neutral-300",
            ),
            id("promptLabel"),
          ],
          [text("Enter your message below")],
        ),
        p(
          [
            attribute("contenteditable", ""),
            attribute(
              "x-on:paste.prevent",
              "document.execCommand('insertText', false, $event.clipboardData.getData('text/plain'))",
            ),
            attribute("aria-labelledby", "promptLabel"),
            role("textbox"),
            class(
              "scroll-on max-h-7 w-full overflow-y-auto px-2 py-1 focus:outline-hidden",
            ),
          ],
          [],
        ),
        textarea([attribute("hidden", ""), name("messageText")], ""),
      ]),
      button(
        [
          class(
            "!ml-auto flex items-center gap-2 whitespace-nowrap bg-black !px-4 !py-2 text-center !text-sm font-medium tracking-wide text-neutral-100 transition hover:opacity-75 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75 dark:bg-white dark:text-black dark:focus-visible:outline-white rounded-lg",
          ),
          type_("button"),
        ],
        [text("Send"), send_horizontal([])],
      ),
    ],
  )
}

fn allies_button() {
  html.div([attribute.class("Allies")], [
    html.button(
      [
        attribute.class(
          " text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full",
        ),
      ],
      [
        svg.svg(
          [
            attribute.class(
              " h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl size-6",
            ),
            attribute("stroke", "currentColor"),
            attribute("stroke-width", "1.5"),
            attribute("viewBox", "0 0 24 24"),
            attribute("fill", "none"),
            attribute("xmlns", "http://www.w3.org/2000/svg"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z",
              ),
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
            ]),
          ],
        ),
        html.br([]),
        html.br([]),
        html.p([attribute.class("text-2xl")], [html.text("Allies")]),
      ],
    ),
  ])
}

fn allies_dropdown() {
  html.div([attribute.class("people")], [
    html.details([attribute.class("dropdown")], [
      html.summary(
        [
          attribute.class(
            "mt-4 px-6 border-0 !border-l !border-r border-gray-600 rounded-lg w-full btn mb-1 bg-transparent hover:bg-transparent text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary  w-full text-2xl",
          ),
        ],
        [
          html.text(
            "Direct
                  Message
                ",
          ),
        ],
      ),
      html.ul(
        [
          attribute.class(
            "bg-transparent rounded-box z-[1] p-2 border border-black max-w-full overflow-y-scroll max-h-96 rounded-tr-none rounded-tl-none",
          ),
          attribute.id("people-popup"),
        ],
        [
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
          html.li([attribute.class("w-full")], [
            html.button(
              [
                attribute.class(
                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                ),
              ],
              [html.span([], [html.text("Person 1")])],
            ),
          ]),
        ],
      ),
    ]),
  ])
}

pub fn chat() -> Element(t) {
  div(
    [
      class("!text-left !absolute"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [div([class("!w-full")], [bottom_bar(info(), buttons())]), chat_section()],
  )
  //       html.div([attribute.class("Name text-3xl font-header")], [

  //       names in message
}

fn messages() {
  [
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
    message_left("Hello", "8:00 AM"),
    message_right("Hi", "8:01 AM"),
  ]
}
