import glacier/should
import gleam/int
import lustre/attribute.{attribute}
import lustre/element.{text}
import lustre/element/html
import pages/chat.{chat_page, message, send_message_form}

fn random_string() {
  int.random(999_999_999) |> int.to_string
}

pub fn chat_page_test() {
  chat_page("1234")
  |> should.equal(
    "<div id=\"page\" class=\"bg-base-100 min-h-screen\"><h1 class=\"text-5xl font-bold text-center absolute mt-4 w-screen\">Online Chat</h1><div class=\"pt-20\"><div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[80vh] h-screen overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><h1 class=\"text-2xl font-bold mt-4\">Chat 1234 started</h1></div><form id=\"send_message_form\" ws-send class=\"my-2 mx-auto w-4/6\"><div class=\"join w-full border-gray-200 border-2 \"><textarea id=\"message_textarea\" name=\"message\" placeholder=\"Send a message\" class=\"w-full textarea textarea-bordered join-item\" style=\"height: 17px;\"></textarea><button id=\"send_message\" class=\"btn bg-secondary hover:bg-accent join-item text-secondary-content\">Send</button></div></form><script>\n        document.getElementById(\"message_textarea\")\n        .addEventListener(\"keydown\", (evt) => {\n          if (evt.keyCode == 13 && !evt.shiftKey){\n            evt.preventDefault();\n            document.getElementById(\"send_message\").click();\n        }});\n        </script></div></div>",
  )
}

pub fn random_chat_page_test() {
  let code = random_string()
  chat_page(code)
  |> should.equal(
    "<div id=\"page\" class=\"bg-base-100 min-h-screen\"><h1 class=\"text-5xl font-bold text-center absolute mt-4 w-screen\">Online Chat</h1><div class=\"pt-20\"><div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[80vh] h-screen overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><h1 class=\"text-2xl font-bold mt-4\">Chat "
    <> code
    <> " started</h1></div><form id=\"send_message_form\" ws-send class=\"my-2 mx-auto w-4/6\"><div class=\"join w-full border-gray-200 border-2 \"><textarea id=\"message_textarea\" name=\"message\" placeholder=\"Send a message\" class=\"w-full textarea textarea-bordered join-item\" style=\"height: 17px;\"></textarea><button id=\"send_message\" class=\"btn bg-secondary hover:bg-accent join-item text-secondary-content\">Send</button></div></form><script>\n        document.getElementById(\"message_textarea\")\n        .addEventListener(\"keydown\", (evt) => {\n          if (evt.keyCode == 13 && !evt.shiftKey){\n            evt.preventDefault();\n            document.getElementById(\"send_message\").click();\n        }});\n        </script></div></div>",
  )
}

pub fn message_test() {
  message("This is a message", "John", "11 dec", "9:05 am", True)
  |> should.equal(
    "<div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><div class=\"chat chat-end\"><div class=\"chat-header\"><time class=\"text-2xs opacity-50 mx-2\">9:05 am</time>John</div><div class=\"chat-bubble whitespace-pre-wrap text-left bg-secondary text-secondary-content\">This is a message</div><div class=\"chat-footer opacity-50 text-xs\">11 dec</div></div></div>",
  )

  message("This is a message", "John", "11 dec", "9:05 am", False)
  |> should.equal(
    "<div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><div class=\"chat chat-start\"><div class=\"chat-header\">John<time class=\"text-2xs opacity-50 mx-2\">9:05 am</time></div><div class=\"chat-bubble whitespace-pre-wrap text-left bg-accent text-secondary-content\">This is a message</div><div class=\"chat-footer opacity-50 text-xs\">11 dec</div></div></div>",
  )
}

pub fn random_message_test() {
  let user_message = random_string()
  let user_name = random_string()
  let date = random_string()
  let time = random_string()

  message(user_message, user_name, date, time, True)
  |> should.equal(
    "<div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><div class=\"chat chat-end\"><div class=\"chat-header\"><time class=\"text-2xs opacity-50 mx-2\">"
    <> time
    <> "</time>"
    <> user_name
    <> "</div><div class=\"chat-bubble whitespace-pre-wrap text-left bg-secondary text-secondary-content\">"
    <> user_message
    <> "</div><div class=\"chat-footer opacity-50 text-xs\">"
    <> date
    <> "</div></div></div>",
  )

  message(user_message, user_name, date, time, False)
  |> should.equal(
    "<div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><div class=\"chat chat-start\"><div class=\"chat-header\">"
    <> user_name
    <> "<time class=\"text-2xs opacity-50 mx-2\">"
    <> time
    <> "</time></div><div class=\"chat-bubble whitespace-pre-wrap text-left bg-accent text-secondary-content\">"
    <> user_message
    <> "</div><div class=\"chat-footer opacity-50 text-xs\">"
    <> date
    <> "</div></div></div>",
  )
}

pub fn send_message_form_test() {
  send_message_form()
  |> should.equal(
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
              attribute.id("message_textarea"),
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
    ),
  )
}
