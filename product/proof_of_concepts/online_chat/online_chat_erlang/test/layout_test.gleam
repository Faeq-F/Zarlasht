import app/pages/layout.{layout}
import glacier/should
import lustre/attribute.{attribute, id}
import lustre/element.{element}
import lustre/element/html

pub fn layout_test() {
  layout([])
  |> should.equal(
    html.html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
      html.head([], [
        html.title([], "Online Chat"),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1"),
        ]),
        html.link([
          attribute.href("/static/favicon.png"),
          attribute.type_("image/x-icon"),
          attribute.rel("icon"),
        ]),
        html.link([
          attribute.href("https://fonts.googleapis.com"),
          attribute.rel("preconnect"),
        ]),
        html.link([
          attribute("crossorigin", ""),
          attribute.href("https://fonts.gstatic.com"),
          attribute.rel("preconnect"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://fonts.googleapis.com/css2?family=Varela+Round&display=swap",
          ),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/pages/app.css"),
        ]),
        html.script([attribute.src("/static/libraries/htmx.min.js")], ""),
        html.script([attribute.src("/static/libraries/htmx-ext/ws.js")], ""),
        html.script([attribute.src("/static/libraries/tailwind.min.js")], ""),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/libraries/daisyui.min.css"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/app.css"),
        ]),
        html.style(
          [attribute.type_("text/tailwindcss")],
          "
          .btn {
            @apply rounded-full;
          }
        ",
        ),
        html.script(
          [],
          "tailwind.config = {
            daisyui: {
              darkTheme: 'forest',
            }
          }",
        ),
      ]),
      html.body([], [
        html.label(
          [attribute.class("swap swap-rotate right-0 fixed m-4 z-10")],
          [
            html.input([
              attribute.value("forest"),
              attribute.class("theme-controller hidden"),
              attribute.type_("checkbox"),
            ]),
          ],
        ),
        html.label([attribute.class("left-0 m-4 fixed z-10")], [
          html.a(
            [
              attribute.href("https://github.com/faeq-f/online_chat"),
              attribute.rel("noopener noreferrer"),
              attribute.target("_blank"),
            ],
            [],
          ),
        ]),
        html.label([attribute.class("left-0 bottom-0 fixed m-4 z-10")], [
          html.p([], [
            html.text("Created by "),
            html.a(
              [
                attribute.class("text-accent"),
                attribute.href("https://faeq-f.github.io/"),
                attribute.rel("noopener noreferrer"),
                attribute.target("_blank"),
              ],
              [html.text("Faeq")],
            ),
          ]),
        ]),
        html.div(
          [
            attribute("ws-connect", "/init_socket"),
            attribute("hx-ext", "ws"),
            attribute.id("app"),
          ],
          [
            html.script(
              [],
              "window.onbeforeunload = function() {return true;};",
            ),
            html.div([attribute.id("page")], []),
          ],
        ),
      ]),
    ]),
  )
}

pub fn layout_elements_test() {
  layout([element("div", [id("div1")], []), element("div", [id("div2")], [])])
  |> should.equal(
    html.html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
      html.head([], [
        html.title([], "Online Chat"),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1"),
        ]),
        html.link([
          attribute.href("/static/favicon.png"),
          attribute.type_("image/x-icon"),
          attribute.rel("icon"),
        ]),
        html.link([
          attribute.href("https://fonts.googleapis.com"),
          attribute.rel("preconnect"),
        ]),
        html.link([
          attribute("crossorigin", ""),
          attribute.href("https://fonts.gstatic.com"),
          attribute.rel("preconnect"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://fonts.googleapis.com/css2?family=Varela+Round&display=swap",
          ),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/pages/app.css"),
        ]),
        html.script([attribute.src("/static/libraries/htmx.min.js")], ""),
        html.script([attribute.src("/static/libraries/htmx-ext/ws.js")], ""),
        html.script([attribute.src("/static/libraries/tailwind.min.js")], ""),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/libraries/daisyui.min.css"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/app.css"),
        ]),
        html.style(
          [attribute.type_("text/tailwindcss")],
          "
          .btn {
            @apply rounded-full;
          }
        ",
        ),
        html.script(
          [],
          "tailwind.config = {
            daisyui: {
              darkTheme: 'forest',
            }
          }",
        ),
      ]),
      html.body([], [
        html.label(
          [attribute.class("swap swap-rotate right-0 fixed m-4 z-10")],
          [
            html.input([
              attribute.value("forest"),
              attribute.class("theme-controller hidden"),
              attribute.type_("checkbox"),
            ]),
          ],
        ),
        html.label([attribute.class("left-0 m-4 fixed z-10")], [
          html.a(
            [
              attribute.href("https://github.com/faeq-f/online_chat"),
              attribute.rel("noopener noreferrer"),
              attribute.target("_blank"),
            ],
            [],
          ),
        ]),
        html.label([attribute.class("left-0 bottom-0 fixed m-4 z-10")], [
          html.p([], [
            html.text("Created by "),
            html.a(
              [
                attribute.class("text-accent"),
                attribute.href("https://faeq-f.github.io/"),
                attribute.rel("noopener noreferrer"),
                attribute.target("_blank"),
              ],
              [html.text("Faeq")],
            ),
          ]),
        ]),
        html.div(
          [
            attribute("ws-connect", "/init_socket"),
            attribute("hx-ext", "ws"),
            attribute.id("app"),
          ],
          [
            html.script(
              [],
              "window.onbeforeunload = function() {return true;};",
            ),
            html.div([attribute.id("page")], [
              element("div", [id("div1")], []),
              element("div", [id("div2")], []),
            ]),
          ],
        ),
      ]),
    ]),
  )
}

pub fn layout_nested_elements_test() {
  layout([
    element("div", [id("div1")], [element("div", [id("div2")], [])]),
    element("div", [id("div3")], [
      element("div", [id("div4")], [element("div", [id("div5")], [])]),
    ]),
  ])
  |> should.equal(
    html.html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
      html.head([], [
        html.title([], "Online Chat"),
        html.meta([
          attribute.name("viewport"),
          attribute("content", "width=device-width, initial-scale=1"),
        ]),
        html.link([
          attribute.href("/static/favicon.png"),
          attribute.type_("image/x-icon"),
          attribute.rel("icon"),
        ]),
        html.link([
          attribute.href("https://fonts.googleapis.com"),
          attribute.rel("preconnect"),
        ]),
        html.link([
          attribute("crossorigin", ""),
          attribute.href("https://fonts.gstatic.com"),
          attribute.rel("preconnect"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href(
            "https://fonts.googleapis.com/css2?family=Varela+Round&display=swap",
          ),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/pages/app.css"),
        ]),
        html.script([attribute.src("/static/libraries/htmx.min.js")], ""),
        html.script([attribute.src("/static/libraries/htmx-ext/ws.js")], ""),
        html.script([attribute.src("/static/libraries/tailwind.min.js")], ""),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/libraries/daisyui.min.css"),
        ]),
        html.link([
          attribute.rel("stylesheet"),
          attribute.href("/static/app.css"),
        ]),
        html.style(
          [attribute.type_("text/tailwindcss")],
          "
          .btn {
            @apply rounded-full;
          }
        ",
        ),
        html.script(
          [],
          "tailwind.config = {
            daisyui: {
              darkTheme: 'forest',
            }
          }",
        ),
      ]),
      html.body([], [
        html.label(
          [attribute.class("swap swap-rotate right-0 fixed m-4 z-10")],
          [
            html.input([
              attribute.value("forest"),
              attribute.class("theme-controller hidden"),
              attribute.type_("checkbox"),
            ]),
          ],
        ),
        html.label([attribute.class("left-0 m-4 fixed z-10")], [
          html.a(
            [
              attribute.href("https://github.com/faeq-f/online_chat"),
              attribute.rel("noopener noreferrer"),
              attribute.target("_blank"),
            ],
            [],
          ),
        ]),
        html.label([attribute.class("left-0 bottom-0 fixed m-4 z-10")], [
          html.p([], [
            html.text("Created by "),
            html.a(
              [
                attribute.class("text-accent"),
                attribute.href("https://faeq-f.github.io/"),
                attribute.rel("noopener noreferrer"),
                attribute.target("_blank"),
              ],
              [html.text("Faeq")],
            ),
          ]),
        ]),
        html.div(
          [
            attribute("ws-connect", "/init_socket"),
            attribute("hx-ext", "ws"),
            attribute.id("app"),
          ],
          [
            html.script(
              [],
              "window.onbeforeunload = function() {return true;};",
            ),
            html.div([attribute.id("page")], [
              element("div", [id("div1")], [element("div", [id("div2")], [])]),
              element("div", [id("div3")], [
                element("div", [id("div4")], [element("div", [id("div5")], [])]),
              ]),
            ]),
          ],
        ),
      ]),
    ]),
  )
}
