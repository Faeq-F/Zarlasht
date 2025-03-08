//// Layout for all pages the site renders

import gleam/list
import lustre/attribute.{attribute, class, href, id, name, rel, src, type_}
import lustre/element.{type Element}
import lustre/element/html.{
  body, div, head, html, img, link, meta, p, script, text, title,
}

/// Layout for all pages the site renders
///
/// The elements provided are placed in a DIV element with the ID `page`
///
pub fn layout(elements: List(Element(t))) -> Element(t) {
  html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
    head([], [
      title([], "Zarlasht"),
      meta([
        name("viewport"),
        attribute("content", "width=device-width, initial-scale=1"),
      ]),
      link([href("/static/favicon.png"), type_("image/x-icon"), rel("icon")]),
      link([rel("stylesheet"), href("/static/app.css")]),
      script([src("/static/libraries/sortable.min.js")], ""),
      script([src("/static/libraries/htmx.min.js")], ""),
      script([src("/static/libraries/htmx-ext/ws.js")], ""),
      script(
        [src("/static/libraries/alpine.focus.min.js"), attribute("defer", "")],
        "",
      ),
      script(
        [src("/static/libraries/alpine.min.js"), attribute("defer", "")],
        "",
      ),
      script([src("/static/libraries/tailwind.min.js")], ""),
      link([
        href("https://cdn.jsdelivr.net/npm/rippleui/dist/css/styles.css"),
        rel("stylesheet"),
      ]),
      link([rel("stylesheet"), href("/static/app.css")]),
      html.style(
        [attribute.type_("text/tailwindcss")],
        "
        @variant dark (&:where(.dark, .dark *));
    ",
      ),
    ]),
    body([], [
      div(
        [
          attribute("ws-connect", "/init_socket"),
          attribute("hx-ext", "ws"),
          id("app"),
        ],
        [
          script([], "window.onbeforeunload = function() {return true;};"),
          div([id("page"), class("h-full w-full")], elements),
        ],
      ),
      div(
        [id("fogWrap"), class("fogWrap")],
        list.repeat(img([src("/static/cloud.png")]), 100),
      ),
      html.style(
        [attribute("lang", "scss")],
        "
        @use 'sass:math';

        $bgAnimation: 100;

        @for $i from 1 through $bgAnimation {
          $scale: math.random(2) - 0.4;

          .fogWrap img:nth-child(#{$i}) {
            left: math.random(120) * 1% - 20;
            animation: raise#{$i} 7 + math.random(15) + s linear infinite;
            animation-delay: math.random(5) - 5 + s;
            transform: scale(0.3 * $i - 0.6) rotate(math.random(360) + deg);
            z-index: $i + 99;

            @keyframes raise#{$i} {
              to {
                bottom: 150vh;
                transform: scale(0.3 * $i - 0.6) rotate(math.random(360) + deg);
              }
            }
          }
        }
        ",
      ),
      script(
        [type_("module")],
        "
        const sass = await import('https://jspm.dev/sass');
        sass.compileString(document.querySelector(\"style[lang=scss]\").innerHTML);
        ",
      ),
    ]),
  ])
}

pub fn stats() {
  p([class("font-text")], [text("Hearts: ")])
}
