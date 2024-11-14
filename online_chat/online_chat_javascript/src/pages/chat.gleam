import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html

pub fn chat_page(chat_code: String) -> String {
  html.div([attribute.class("bg-base-100 min-h-screen"), attribute.id("page")], [
    html.h1(
      [attribute.class("text-5xl font-bold text-center absolute mt-4 w-screen")],
      [element.text("Online Chat")],
    ),
    html.div([attribute.class("pt-20")], [
      html.div(
        [
          attribute.class(
            "w-4/6 max-h-[80vh] h-screen overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4",
          ),
          attribute.id("chat"),
          attribute("hx-swap-oob", "beforeend"),
        ],
        [
          html.h1([attribute.class("text-2xl font-bold mt-4")], [
            element.text("Chat " <> chat_code <> " started"),
          ]),
        ],
      ),
      send_message_form(),
    ]),
  ])
  |> element.to_string
}

pub fn message(message: String, me: Bool) -> String {
  html.div(
    [
      attribute.class(
        "w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4",
      ),
      attribute.id("chat"),
      attribute("hx-swap-oob", "beforeend"),
    ],
    [
      case me {
        True -> {
          html.div([attribute.class("chat chat-end")], [
            html.div(
              [
                attribute.class(
                  "chat-bubble whitespace-pre-wrap text-left bg-secondary text-secondary-content",
                ),
              ],
              [text(message)],
            ),
          ])
        }
        _ -> {
          html.div([attribute.class("chat chat-start")], [
            html.div(
              [
                attribute.class(
                  "chat-bubble whitespace-pre-wrap text-left bg-accent text-secondary-content",
                ),
              ],
              [text(message)],
            ),
          ])
        }
      },
    ],
  )
  |> element.to_string
}

pub fn send_message_form() -> Element(form) {
  html.form(
    [
      attribute.id("send_message_form"),
      attribute.class("my-2 mx-auto w-4/6"),
      attribute("ws-send", ""),
    ],
    [
      html.div([attribute.class("join w-full border-gray-200 border-2 ")], [
        html.textarea(
          [
            attribute.name("message"),
            attribute.placeholder("Send a message"),
            attribute("style", "height: 17px;"),
            attribute.class("w-full textarea textarea-bordered join-item"),
          ],
          "",
        ),
        html.button(
          [
            attribute.class(
              "btn bg-secondary hover:bg-accent join-item text-secondary-content",
            ),
            attribute.id("send_message"),
          ],
          [text("Send")],
        ),
      ]),
    ],
  )
}
