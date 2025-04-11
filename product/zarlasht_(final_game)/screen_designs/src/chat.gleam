import components/bottom_bar.{bottom_bar}
import components/lucide_lustre.{
  circle_x, dices, map, send_horizontal, users_round,
}
import gleam/list
import gleam/string.{join}
import layout.{stats}
import lustre/attribute.{attribute, class, id, name, role, style, type_}
import lustre/element.{type Element}
import lustre/element/html.{br, button, div, h1, label, p, span, text, textarea}

fn info() {
  div([class("flex")], [
    div(
      [
        class("btn !bg-gray-100 font-header !text-lg"),
        style([#("cursor", "default")]),
      ],
      [stats()],
    ),
    div(
      [
        class("btn-group  btn-group-scrollable !ml-[10px]"),
        style([#("height", "2.5rem")]),
      ],
      [
        div([class("popover popover-hover contents")], [
          label(
            [
              class(join(
                [
                  "popover-trigger btn border !rounded-r-none",
                  "bg-black/15 hover:bg-black/30",
                  "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                  "border-black/40 text-current", "transition-all duration-500",
                ],
                " ",
              )),
            ],
            [users_round([])],
          ),
          div(
            [
              class("popover-content w-32 popover-top-left !ml-26  !fixed"),
              style([#("width", "fit-content")]),
            ],
            [
              div([class("popover-arrow")], []),
              div([], [
                div(
                  [
                    class(
                      "btn-group btn-group-vertical btn-group-scrollable w-full max-w-full",
                    ),
                  ],
                  [
                    button([class("btn w-full flex"), id("setLight")], [
                      div([class("flex-1 text-center font-text pl-2")], [
                        text("John"),
                      ]),
                    ]),
                    button([class("btn w-full flex"), id("setLight")], [
                      div([class("flex-1 text-center font-text pl-2")], [
                        text("Mubz"),
                      ]),
                    ]),
                    button([class("btn w-full flex"), id("setLight")], [
                      div([class("flex-1 text-center font-text pl-2")], [
                        text("Dennis"),
                      ]),
                    ]),
                    button([class("btn w-full flex"), id("setLight")], [
                      div([class("flex-1 text-center font-text pl-2")], [
                        text("Mahid"),
                      ]),
                    ]),
                    button([class("btn w-full flex"), id("setLight")], [
                      div([class("flex-1 text-center font-text pl-2")], [
                        text("Hossam"),
                      ]),
                    ]),
                  ],
                ),
              ]),
            ],
          ),
        ]),
        button(
          [
            class(join(
              [
                "btn border font-text !text-xl lg:inline-flex ",
                "bg-black/15 hover:bg-black/30",
                "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                "border-black/40 text-current", "transition-all duration-500",
              ],
              " ",
            )),
          ],
          [text("Allies")],
        ),
      ],
    ),
  ])
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

fn header(chat: String) {
  div([id("Header")], [
    h1([class("font-subheader !text-4xl text-center !mt-8")], [text(chat)]),
  ])
}

fn chat_section() {
  div(
    [
      class(
        "relative flex flex-grow flex-col px-12 justify-end Chat overflowy-scroll",
      ),
      style([#("height", "calc(100% - 4.5rem)")]),
    ],
    [
      header("Allies"),
      div(
        [
          class(
            "mx-12 py-1 px-2 overflow-y-scroll overflow-x-hidden max-h-[80vh] h-full mt-10 !border rounded-box !border-neutral-500  rounded-xl",
          ),
        ],
        messages(),
      ),
      send_message_section(),
    ],
  )
}

fn format_message(message: String) {
  list.intersperse(
    list.map(string.split(string.trim_end(message), "\n"), fn(x) { text(x) }),
    br([]),
  )
}

fn message_left(
  message: String,
  author: String,
  author_color: String,
  time: String,
) {
  div(
    [
      class(
        "font-text rounded-lg rounded-tl-none my-1 p-2 text-sm flex flex-col relative max-w-[80vw] bg-white/70 speech-bubble-left",
      ),
      style([#("width", "fit-content"), #("margin", "0.5rem auto 0 10px")]),
    ],
    [
      p([], format_message(message)),
      p([class("text-gray-600 text-xs text-right leading-none")], [
        span([class("font-subheader !mr-2 " <> author_color)], [text(author)]),
        text(time),
      ]),
    ],
  )
}

fn message_right(
  message: String,
  author: String,
  author_color: String,
  time: String,
) {
  div(
    [
      class(
        "font-text rounded-lg rounded-tr-none my-1 p-2 text-sm flex flex-col relative max-w-[80vw] bg-white/70 speech-bubble-right",
      ),
      style([#("width", "fit-content"), #("margin", "0.5rem 10px 0 auto")]),
    ],
    [
      p([], format_message(message)),
      p([class("text-gray-600 text-xs text-right leading-none")], [
        text(time),
        span([class("font-subheader !ml-2 " <> author_color)], [text(author)]),
      ]),
    ],
  )
}

fn send_message_section() {
  div(
    [
      class(
        "!mt-2 !h-[15%] flex w-full flex-col overflow-hidden border-neutral-300 bg-white/50 text-neutral-600 has-[p:focus]:outline-2 has-[p:focus]:outline-offset-2 has-[p:focus]:outline-black dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300 dark:has-[p:focus]:outline-white rounded-xl !border !border-neutral-500 ",
      ),
    ],
    [
      div([class("p-2")], [
        p(
          [
            class(
              "pb-1 pl-2 text-sm font-text font-bold text-neutral-600 opacity-60 dark:text-neutral-300",
            ),
            id("promptLabel"),
          ],
          [text("Enter your message below")],
        ),
        p(
          [
            id("messageBox"),
            attribute("contenteditable", ""),
            attribute(
              "x-on:paste.prevent",
              "document.execCommand('insertText', false, $event.clipboardData.getData('text/plain'))",
            ),
            attribute("aria-labelledby", "promptLabel"),
            role("textbox"),
            class(
              "font-text scroll-on max-h-8 h-8 w-full overflow-y-auto px-2 py-1 !outline-none",
            ),
          ],
          [],
        ),
        textarea([attribute("hidden", ""), name("messageText")], ""),
      ]),
      button(
        [
          class(
            "font-text h-[2rem] !mr-1 text-white !ml-auto flex items-center gap-2 whitespace-nowrap hover:bg-black bg-black/80 !px-4 !py-2 text-center !text-sm font-medium tracking-wide text-neutral-100 transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75 dark:bg-white dark:text-black dark:focus-visible:outline-white rounded-lg",
          ),
          type_("button"),
        ],
        [text("Send"), send_horizontal([class("w-4")])],
      ),
    ],
  )
}

pub fn chat() -> Element(t) {
  div(
    [
      class("!text-left !absolute !z-[999]"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full z-30 absolute")], [bottom_bar(info(), buttons())]),
      chat_section(),
    ],
  )
}

fn messages() {
  [
    message_left("Hello", "John", "text-red-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-orange-500", "8:01 AM"),
    message_left(
      "Hello this is a longer message",
      "John",
      "text-amber-500",
      "8:00 AM",
    ),
    message_right(
      "Hi, this one is even longer (newlines should be next)",
      "Faeq",
      "text-yellow-500",
      "8:01 AM",
    ),
    message_left(
      "Hellooooooooo ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo",
      "John",
      "text-lime-500",
      "8:00 AM",
    ),
    message_right(
      "time to see how this looks\nnext\nscreen designs\ntime to see how this looks",
      "Faeq",
      "text-green-500",
      "8:01 AM",
    ),
    message_left("Hello", "John", "text-emerald-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-teal-500", "8:01 AM"),
    message_left("Hello", "John", "text-cyan-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-sky-500", "8:01 AM"),
    message_left("Hello", "John", "text-blue-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-indigo-500", "8:01 AM"),
    message_left("Hello", "John", "text-violet-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-purple-500", "8:01 AM"),
    message_left("Hello", "John", "text-fuchsia-500", "8:00 AM"),
    message_left("Hello", "John", "text-red-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-orange-500", "8:01 AM"),
    message_left("Hello", "John", "text-amber-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-yellow-500", "8:01 AM"),
    message_left("Hello", "John", "text-lime-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-green-500", "8:01 AM"),
    message_left("Hello", "John", "text-emerald-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-teal-500", "8:01 AM"),
    message_left("Hello", "John", "text-cyan-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-sky-500", "8:01 AM"),
    message_left("Hello", "John", "text-blue-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-indigo-500", "8:01 AM"),
    message_left("Hello", "John", "text-violet-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-purple-500", "8:01 AM"),
    message_left("Hello", "John", "text-fuchsia-500", "8:00 AM"),
    message_left("Hello", "John", "text-red-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-orange-500", "8:01 AM"),
    message_left("Hello", "John", "text-amber-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-yellow-500", "8:01 AM"),
    message_left("Hello", "John", "text-lime-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-green-500", "8:01 AM"),
    message_left("Hello", "John", "text-emerald-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-teal-500", "8:01 AM"),
    message_left("Hello", "John", "text-cyan-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-sky-500", "8:01 AM"),
    message_left("Hello", "John", "text-blue-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-indigo-500", "8:01 AM"),
    message_left("Hello", "John", "text-violet-500", "8:00 AM"),
    message_right("Hi", "Faeq", "text-purple-500", "8:01 AM"),
    message_left("Hello", "John", "text-fuchsia-500", "8:00 AM"),
  ]
}
