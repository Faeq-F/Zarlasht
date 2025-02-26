import components/lucide_lustre.{laptop, moon, sun_medium, sun_moon}
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, src, style}
import lustre/element.{fragment}
import lustre/element/html.{button, div, img, label, text}

pub fn theme_switch() {
  fragment([
    div([class("popover popover-hover contents")], [
      label(
        [
          class(join(
            [
              "popover-trigger btn border !rounded-r-none !rounded-full",
              "bg-black/15 hover:bg-black/30",
              "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
              "border-black/40 text-current", "transition-all duration-500",
            ],
            " ",
          )),
        ],
        [sun_moon([])],
      ),
      div(
        [
          class("popover-content w-32 popover-top-right !fixed"),
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
                  sun_medium([]),
                  div([class("flex-1 text-center font-text pl-2")], [
                    text("Light"),
                  ]),
                ]),
                button([class("btn w-full"), id("setDark")], [
                  moon([]),
                  div([class("flex-1 text-center font-text pl-2")], [
                    text("Dark"),
                  ]),
                ]),
                button([class("btn w-full"), id("setSystem")], [
                  laptop([]),
                  div([class("flex-1 text-right font-text pl-2")], [
                    text("System"),
                  ]),
                ]),
              ],
            ),
          ]),
        ],
      ),
    ]),
    functionality(),
  ])
}

fn functionality() {
  html.script(
    [],
    "
      function setDarkTheme() {
        document.documentElement.classList.add(\"dark\");
        localStorage.theme = \"dark\";
      };

      function setLightTheme() {
        document.documentElement.classList.remove(\"dark\");
        localStorage.theme = \"light\";
      };

      function setSystemTheme() {
        localStorage.removeItem(\"theme\");
        if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
          document.documentElement.classList.add('dark');
        } else {
          document.documentElement.classList.remove('dark');
        };
      }

      document.getElementById(\"setLight\").addEventListener(\"click\", setLightTheme);
      document.getElementById(\"setDark\").addEventListener(\"click\", setDarkTheme);
      document.getElementById(\"setSystem\").addEventListener(\"click\", setSystemTheme);

      setSystemTheme();
    ",
  )
}
