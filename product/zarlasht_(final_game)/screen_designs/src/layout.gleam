//// Layout for all pages the site renders

import components/lucide_lustre.{github, moon, sun}
import components/theme_switch.{theme_switch}
import gleam/list
import lustre/attribute.{
  attribute, class, href, id, name, rel, src, style, target, type_,
}
import lustre/element.{type Element}
import lustre/element/html.{
  a, body, div, head, html, img, label, link, meta, p, script, text, title,
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
      script([src("/static/libraries/htmx.min.js")], ""),
      script([src("/static/libraries/htmx-ext/ws.js")], ""),
      script([src("/static/libraries/tailwind.min.js")], ""),
      link([
        href("https://cdn.jsdelivr.net/npm/rippleui/dist/css/styles.css"),
        rel("stylesheet"),
      ]),
      script(
        [
          src("https://cdn.jsdelivr.net/npm/alpinejs@3.14.8/dist/cdn.min.js"),
          attribute("defer", ""),
        ],
        "",
      ),
      link([rel("stylesheet"), href("/static/app.css")]),
      script(
        [],
        "
        tailwind.config = {
          important: true,
          darkMode: \"class\",
          i18n: {
            locales: [\"en-US\"],
            defaultLocale: \"en-US\",
          },
          future: {
            purgeLayersByDefault: true,
          },
          corePlugins: {
            preflight: false,
          },
        }
      ",
      ),
    ]),
    body([], [
      div([class("absolute top-0 right-0 m-4 z-10")], [theme_switch()]),
      label([class("left-0 m-4 fixed z-10 top-0")], [
        a(
          [
            href("https://github.com/faeq-f/zarlasht"),
            rel("noopener noreferrer"),
            target("_blank"),
          ],
          [github([])],
        ),
      ]),
      label([class("left-0 bottom-0 fixed m-4 z-10")], [
        p([], [
          text("Created by "),
          a(
            [
              class("text-green-8"),
              href("https://faeq-f.github.io/"),
              rel("noopener noreferrer"),
              target("_blank"),
            ],
            [text("Faeq")],
          ),
        ]),
      ]),
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

@layer tailwind-base, tailwind-utilities;

@layer tailwind-base {
  @tailwind base;
}

@layer tailwind-utilities {
  @tailwind components;
  @tailwind utilities;
}

@import 'primeicons/primeicons.css';
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;

    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;

    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;

    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;

    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;

    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;

    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;

    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;

    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;

    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;

    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;

    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;

    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;

    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;

    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;

    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;

    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}

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
        "const sass = await import('https://jspm.dev/sass');
        sass.compileString(document.querySelector(\"style[lang=scss]\").innerHTML);",
      ),
    ]),
  ])
}
