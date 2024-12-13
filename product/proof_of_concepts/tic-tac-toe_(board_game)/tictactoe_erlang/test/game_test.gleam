import app/pages/game.{game_page, message, send_message_form}
import glacier/should
import lustre/attribute.{attribute}
import lustre/element.{text}
import lustre/element/html

pub fn game_page_test() {
  game_page()
  |> should.equal(
    "<div id=\"page\" class=\"hero bg-base-100 min-h-full\"><h1 class=\"text-5xl font-bold mt-4\">Tic-Tac-Toe</h1><div class=\"divider lg:divider-horizontal absolute top-1/2 -translate-y-1/2 h-96\"></div><div class=\"hero-content text-center absolute top-1/2 -translate-y-1/2 min-w-full h-screen pt-16 pb-12\"><div class=\"grid lg:grid-cols-2 grid-cols-1 gap-10 w-full h-full\"><div class=\"card text-center h-full\"><div id=\"player1\" class=\"w-4/6 h-1/7 rounded-3xl p-4\"></div><div id=\"game\" class=\"m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full\"></div><div id=\"player2\" class=\"w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-auto\"></div></div><div class=\"card text-center h-screen lg:h-full mt-32 lg:mt-0\"><div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-screen overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><h1 class=\"text-2xl font-bold mt-4\">Chat</h1></div><form id=\"send_message_form\" ws-send class=\"my-2 mx-auto w-4/6\"><div class=\"join w-full border-gray-200 border-2 \"><textarea id=\"message_textarea\" name=\"message\" placeholder=\"Send a message\" class=\"w-full textarea textarea-bordered join-item\" style=\"height: 17px;\"></textarea><button id=\"send_message\" class=\"btn bg-secondary hover:bg-accent join-item text-secondary-content\">Send</button></div></form><script>\n                  document.getElementById(\"message_textarea\")\n                  .addEventListener(\"keydown\", (evt) => {\n                    if (evt.keyCode == 13 && !evt.shiftKey){\n                      evt.preventDefault();\n                      document.getElementById(\"send_message\").click();\n                  }});\n                  </script></div></div></div><div id=\"status\"></div></div>",
  )
}

pub fn message_test() {
  message("Message text", True)
  |> should.equal(
    "<div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><div class=\"chat chat-end\"><div class=\"chat-bubble whitespace-pre-wrap text-left bg-secondary text-secondary-content\">Message text</div></div></div>",
  )

  message("Message text", False)
  |> should.equal(
    "<div id=\"chat\" hx-swap-oob=\"beforeend\" class=\"w-4/6 max-h-[85vh] h-full overflow-y-scroll border-gray-200 border-2 mx-auto my-0 rounded-3xl p-4\"><div class=\"chat chat-start\"><div class=\"chat-bubble whitespace-pre-wrap text-left bg-accent text-secondary-content\">Message text</div></div></div>",
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
