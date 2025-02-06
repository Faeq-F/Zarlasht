//// Layout for all pages the site renders

import lucide_lustre.{github, moon, sun}
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg

/// Layout for all pages the site renders
///
/// The elements provided are placed in a DIV element with the ID `page`
///
pub fn layout(elements: List(Element(t))) -> Element(t) {
  html.html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
    html.head([], [
      html.title([], "Zarlasht"),
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
        attribute.rel("stylesheet"),
        attribute.href(
          "https://cdn.jsdelivr.net/npm/tw-elements/css/tw-elements.min.css",
        ),
      ]),
      html.link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
      html.script([attribute.src("/static/libraries/htmx.min.js")], ""),
      html.script([attribute.src("/static/libraries/htmx-ext/ws.js")], ""),
      html.script([attribute.src("/static/libraries/tailwind.min.js")], ""),
      html.link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
      html.script(
        [],
        "
        tailwind.config = {
          important: true,
          darkMode: \"class\",
          i18n: {
            locales: [\"en-US\"],
            defaultLocale: \"en-US\",
          },
          theme: {
            extend: {
              backgroundImage: (theme) => ({
                check: \"url('/icons/check.svg')\",
                landscape: \"url('/images/landscape/2.jpg')\",
              }),
            },
          },
          variants: {
            extend: {
              backgroundColor: [\"checked\"],
              borderColor: [\"checked\"],
              inset: [\"checked\"],
              zIndex: [\"hover\", \"active\"],
            },
          },
          plugins: [],
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
    html.body([], [
      theme_switch(),
      html.label([attribute.class("left-0 m-4 fixed z-10 top-0")], [
        html.a(
          [
            attribute.href("https://github.com/faeq-f/zarlasht"),
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
          html.div(
            [attribute.id("page"), attribute.class("h-full w-full")],
            elements,
          ),
        ],
      ),
      html.div([attribute.id("fogWrap"), attribute.class("fogWrap")], [
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
        html.img([attribute.src("/static/cloud.png")]),
      ]),
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
      html.script(
        [attribute.type_("module")],
        "const sass = await import('https://jspm.dev/sass');
        sass.compileString(document.querySelector(\"style[lang=scss]\").innerHTML);",
      ),
      html.script(
        [
          attribute.src(
            "https://cdn.jsdelivr.net/npm/tw-elements/js/tw-elements.umd.min.js",
          ),
        ],
        "",
      ),
      html.script(
        [],
        "
      // On page load or when changing themes, best to add inline in `head` to avoid FOUC
if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
  document.documentElement.classList.add('dark');
} else {
  document.documentElement.classList.remove('dark');
};

function setDarkTheme() {
  document.documentElement.classList.add(\"dark\");
  localStorage.theme = \"dark\";
};

function setLightTheme() {
  document.documentElement.classList.remove(\"dark\");
  localStorage.theme = \"light\";
};

function onThemeSwitcherItemClick(event) {
  const theme = event.target.dataset.theme;

  if (theme === \"system\") {
    localStorage.removeItem(\"theme\");
    setSystemTheme();
  } else if (theme === \"dark\") {
    setDarkTheme();
  } else {
    setLightTheme();
  }
};

const themeSwitcherItems = document.querySelectorAll(\"#theme-switcher\");
themeSwitcherItems.forEach((item) => {
  item.addEventListener(\"click\", onThemeSwitcherItemClick);
});







//not show theme options on first load
document.getElementById(\"themeSwitcher\").removeAttribute(\"data-twe-dropdown-show\");
document.querySelectorAll(\"[aria-labelledby=\\\"themeSwitcher\\\"]\")[0].removeAttribute(\"data-twe-dropdown-show\");
      ",
      ),
    ]),
  ])
}

fn theme_switch() {
  html.div(
    [
      attribute.class("w-8 right-0 fixed m-4 z-10 top-0"),
      attribute.id("theme-switcher"),
    ],
    [
      html.button(
        [
          attribute("data-twe-dropdown-show", ""),
          attribute("aria-expanded", "true"),
          attribute("data-twe-dropdown-position", "dropend"),
          attribute("data-twe-dropdown-toggle-ref", ""),
          attribute.id("themeSwitcher"),
          attribute.type_("button"),
          attribute.class(
            "rounded-2 flex items-center justify-center whitespace-nowrap px-1.5 py-2 uppercase text-black/60 transition duration-200 hover:text-black/80 hover:ease-in-out focus:text-black/80 active:text-black/80 motion-reduce:transition-none dark:text-white/60 dark:hover:text-white/80 dark:focus:text-white/80 dark:active:text-white/80 sm:p-2",
          ),
        ],
        [
          svg.svg(
            [
              attribute.class("inline-block h-5 w-5"),
              attribute("fill", "currentColor"),
              attribute("viewBox", "0 0 24 24"),
              attribute("xmlns", "http://www.w3.org/2000/svg"),
            ],
            [
              svg.path([
                attribute(
                  "d",
                  "M12 2.25a.75.75 0 01.75.75v2.25a.75.75 0 01-1.5 0V3a.75.75 0 01.75-.75zM7.5 12a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM18.894 6.166a.75.75 0 00-1.06-1.06l-1.591 1.59a.75.75 0 101.06 1.061l1.591-1.59zM21.75 12a.75.75 0 01-.75.75h-2.25a.75.75 0 010-1.5H21a.75.75 0 01.75.75zM17.834 18.894a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 10-1.061 1.06l1.59 1.591zM12 18a.75.75 0 01.75.75V21a.75.75 0 01-1.5 0v-2.25A.75.75 0 0112 18zM7.758 17.303a.75.75 0 00-1.061-1.06l-1.591 1.59a.75.75 0 001.06 1.061l1.591-1.59zM6 12a.75.75 0 01-.75.75H3a.75.75 0 010-1.5h2.25A.75.75 0 016 12zM6.697 7.757a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 00-1.061 1.06l1.59 1.591z",
                ),
              ]),
            ],
          ),
        ],
      ),
      html.ul(
        [
          attribute("data-popper-placement", "bottom-start"),
          attribute("data-twe-dropdown-show", ""),
          attribute(
            "style",
            "position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 38px);",
          ),
          attribute("data-twe-dropdown-menu-ref", ""),
          attribute("aria-labelledby", "themeSwitcher"),
          attribute.class(
            "absolute z-[1000] float-left m-0 hidden w-[120px] list-none overflow-hidden rounded-lg border-none bg-white bg-clip-padding text-left text-base shadow-lg data-[twe-dropdown-show]:block dark:bg-surface-dark",
          ),
        ],
        [
          html.li([], [
            html.a(
              [
                attribute("data-twe-dropdown-item-ref", ""),
                attribute("data-theme", "light"),
                attribute.href("#"),
                attribute.class(
                  "block w-full whitespace-nowrap bg-white px-3 py-2 text-sm font-normal text-neutral-700 hover:bg-zinc-200/60 focus:bg-zinc-200/60 focus:outline-none active:bg-zinc-200/60 active:no-underline dark:bg-surface-dark dark:text-white dark:hover:bg-neutral-800/25 dark:focus:bg-neutral-800/25 dark:active:bg-neutral-800/25",
                ),
              ],
              [
                html.div([attribute.class("pointer-events-none")], [
                  html.div(
                    [
                      attribute("data-theme-icon", "light"),
                      attribute.class(
                        "inline-block w-[24px] text-center align-middle text-primary",
                      ),
                    ],
                    [
                      svg.svg(
                        [
                          attribute.class("inline-block h-5 w-5"),
                          attribute("fill", "currentColor"),
                          attribute("viewBox", "0 0 24 24"),
                          attribute("xmlns", "http://www.w3.org/2000/svg"),
                        ],
                        [
                          svg.path([
                            attribute(
                              "d",
                              "M12 2.25a.75.75 0 01.75.75v2.25a.75.75 0 01-1.5 0V3a.75.75 0 01.75-.75zM7.5 12a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM18.894 6.166a.75.75 0 00-1.06-1.06l-1.591 1.59a.75.75 0 101.06 1.061l1.591-1.59zM21.75 12a.75.75 0 01-.75.75h-2.25a.75.75 0 010-1.5H21a.75.75 0 01.75.75zM17.834 18.894a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 10-1.061 1.06l1.59 1.591zM12 18a.75.75 0 01.75.75V21a.75.75 0 01-1.5 0v-2.25A.75.75 0 0112 18zM7.758 17.303a.75.75 0 00-1.061-1.06l-1.591 1.59a.75.75 0 001.06 1.061l1.591-1.59zM6 12a.75.75 0 01-.75.75H3a.75.75 0 010-1.5h2.25A.75.75 0 016 12zM6.697 7.757a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 00-1.061 1.06l1.59 1.591z",
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                  html.span(
                    [
                      attribute.class("text-primary"),
                      attribute("data-theme-name", "light"),
                    ],
                    [html.text("Light")],
                  ),
                ]),
              ],
            ),
          ]),
          html.li([], [
            html.a(
              [
                attribute("data-twe-dropdown-item-ref", ""),
                attribute("data-theme", "dark"),
                attribute.href("#"),
                attribute.class(
                  "block w-full whitespace-nowrap bg-white px-3 py-2 text-sm font-normal text-neutral-700 hover:bg-zinc-200/60 focus:bg-zinc-200/60 focus:outline-none active:bg-zinc-200/60 active:no-underline dark:bg-surface-dark dark:text-white dark:hover:bg-neutral-800/25 dark:focus:bg-neutral-800/25 dark:active:bg-neutral-800/25",
                ),
              ],
              [
                html.div([attribute.class("pointer-events-none")], [
                  html.div(
                    [
                      attribute("data-theme-icon", "dark"),
                      attribute.class(
                        "-mt-1 inline-block w-[24px] text-center align-middle",
                      ),
                    ],
                    [
                      svg.svg(
                        [
                          attribute.class("inline-block h-4 w-4"),
                          attribute("fill", "currentColor"),
                          attribute("viewBox", "0 0 24 24"),
                          attribute("xmlns", "http://www.w3.org/2000/svg"),
                        ],
                        [
                          svg.path([
                            attribute("clip-rule", "evenodd"),
                            attribute(
                              "d",
                              "M9.528 1.718a.75.75 0 01.162.819A8.97 8.97 0 009 6a9 9 0 009 9 8.97 8.97 0 003.463-.69.75.75 0 01.981.98 10.503 10.503 0 01-9.694 6.46c-5.799 0-10.5-4.701-10.5-10.5 0-4.368 2.667-8.112 6.46-9.694a.75.75 0 01.818.162z",
                            ),
                            attribute("fill-rule", "evenodd"),
                          ]),
                        ],
                      ),
                    ],
                  ),
                  html.span(
                    [attribute.class(""), attribute("data-theme-name", "dark")],
                    [html.text("Dark")],
                  ),
                ]),
              ],
            ),
          ]),
        ],
      ),
    ],
  )
}
