import app/pages/components/lucide_lustre.{laptop, moon, sun_medium, sun_moon}
import gleam/string.{join}
import lustre/attribute.{attribute, checked, class, for, id, role, style, type_}
import lustre/element.{fragment}
import lustre/element/html.{button, div, input, label, span, text}

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
          class("popover-content w-32 popover-top-right !fixed h-46"),
          style([#("width", "fit-content")]),
        ],
        [
          div([class("popover-arrow")], []),
          div([], [
            div(
              [
                class(
                  "btn-group btn-group-vertical btn-group-scrollable w-full max-w-full h-46",
                ),
              ],
              [
                button([class("btn w-full flex"), id("setLight")], [
                  sun_medium([]),
                  div([class("flex-1 text-center font-text pl-7")], [
                    text("Light"),
                  ]),
                ]),
                button([class("btn w-full"), id("setDark")], [
                  moon([]),
                  div([class("flex-1 text-center font-text pl-6")], [
                    text("Dark"),
                  ]),
                ]),
                button([class("btn w-full"), id("setSystem")], [
                  laptop([]),
                  div([class("flex-1 text-right font-text")], [text("System")]),
                ]),
                animation_toggle(),
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

fn animation_toggle() {
  html.div([attribute.class("flex items-center ps-4 !mt-1")], [
    html.label(
      [
        attribute.class("w-full ms-2 font-text text-sm"),
        attribute.for("bordered-checkbox-2"),
      ],
      [html.text("Background"), html.br([]), text("Animation")],
    ),
    html.input([
      attribute.class("switch switch-ghost-primary !w-14"),
      attribute.type_("checkbox"),
      attribute.checked(True),
      attribute(
        "onclick",
        "document.getElementById('fogWrap').classList.toggle('hidden')",
      ),
      style([
        #("rotate", "270deg"),
        #("--switch-bg-checked", "black"),
        #("--switch-border-checked", "black"),
        #("--switch-border-hover", "black"),
      ]),
    ]),
  ])
}
