//// Layout for all pages the site renders

import lucide_lustre.{github, moon, sun}
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html

/// Layout for all pages the site renders
///
/// The elements provided are placed in a DIV element with the ID `page`
///
pub fn layout(elements: List(Element(t))) -> Element(t) {
  html.html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
    html.head([], [
      html.title([], "Pong"),
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
      html.link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
      html.script([attribute.src("/static/libraries/htmx.min.js")], ""),
      html.script([attribute.src("/static/libraries/htmx-ext/ws.js")], ""),
      html.script([attribute.src("/static/libraries/tailwind.min.js")], ""),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href("/static/libraries/daisyui.min.css"),
      ]),
      html.link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
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
      html.label([attribute.class("swap swap-rotate right-0 fixed m-4 z-10")], [
        html.input([
          attribute.value("forest"),
          attribute.class("theme-controller hidden"),
          attribute.type_("checkbox"),
        ]),
        sun([class("swap-off h-10 w-10")]),
        moon([class("swap-on h-10 w-10")]),
      ]),
      html.label([attribute.class("left-0 m-4 fixed z-10")], [
        html.a(
          [
            attribute.href("https://github.com/faeq-f/online_chat"),
            attribute.rel("noopener noreferrer"),
            attribute.target("_blank"),
          ],
          [github([])],
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
          html.script([], "window.onbeforeunload = function() {return true;};"),
          html.div([attribute.id("page")], elements),
        ],
      ),
    ]),
  ])
}
