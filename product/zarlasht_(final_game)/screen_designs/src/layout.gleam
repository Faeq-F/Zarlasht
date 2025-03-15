//// Layout for all pages the site renders

import components/lucide_lustre.{biceps_flexed, dot, hand, heart, heart_crack}
import gleam/float
import gleam/int
import gleam/list
import lustre/attribute.{attribute, class, href, id, name, rel, src, type_}
import lustre/element.{type Element}
import lustre/element/html.{
  body, div, head, html, img, link, meta, script, span, title,
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
          div(
            [id("page"), class("h-full w-full")],
            list.flatten([
              elements,
              fog_styles(),
              [
                div(
                  [id("fogWrap"), class("fogWrap")],
                  list.repeat(img([src("/static/cloud.png")]), 100),
                ),
              ],
            ]),
          ),
        ],
      ),
    ]),
  ])
}

pub fn stats() {
  span([], [
    heart([class("fill-[red]/40 !inline")]),
    heart([class("fill-[red]/40 !inline")]),
    heart([class("fill-[red]/40 !inline")]),
    heart([class("fill-[red]/40 !inline")]),
    heart([class("fill-[red]/40 !inline")]),
    heart([class("fill-[red]/40 !inline")]),
    heart([class("fill-[red]/40 !inline")]),
    heart_crack([class(" !inline")]),
    heart_crack([class(" !inline")]),
    heart_crack([class(" !inline")]),
    dot([class("!inline")]),
    biceps_flexed([class("fill-[gray]/40 !inline")]),
    biceps_flexed([class("fill-[gray]/40 !inline")]),
    biceps_flexed([class("fill-[gray]/40 !inline")]),
    biceps_flexed([class("fill-[gray]/40 !inline")]),
    hand([class(" !inline")]),
    hand([class(" !inline")]),
  ])
}

fn fog_styles() {
  list.map(list.range(0, 100), fn(i) {
    let left = float.floor(float.random() *. 120.0 -. 20.0)
    let animation_duration = float.floor(7.0 +. float.random() *. 15.0)
    let animation_delay = float.floor(float.random() *. 5.0 -. 5.0)
    let rotation = float.floor(float.random() *. 360.0)
    html.style([], "
      .fogWrap img:nth-child(" <> int.to_string(i) <> ") {
        left: " <> float.to_string(left) <> "%;
        animation: raise" <> int.to_string(i) <> " " <> float.to_string(
      animation_duration,
    ) <> "s linear infinite;
        animation-delay: " <> float.to_string(animation_delay) <> "s;
        transform: scale(calc(0.3 * " <> int.to_string(i) <> " - 0.6)) rotate(" <> float.to_string(
      rotation,
    ) <> "deg);
        z-index: calc(" <> int.to_string(i) <> " + 1);
      }

      @keyframes raise" <> int.to_string(i) <> " {
        to {
          bottom: 150vh;
          transform: scale(calc(0.3 * " <> int.to_string(i) <> " - 0.6)) rotate(" <> float.to_string(
      rotation,
    ) <> "deg);
        }
      }
      ")
  })
}
