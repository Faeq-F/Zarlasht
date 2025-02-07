import components/lucide_lustre.{laptop, moon, sun_medium, sun_moon}
import lustre/attribute.{attribute, class, id}
import lustre/element.{fragment}
import lustre/element/html.{div, label}

pub fn theme_switch() {
  fragment([
    div([class("popover popover-hover")], [
      label([class("popover-trigger my-2 btn btn-solid-primary")], [
        sun_moon([]),
      ]),
      div([class("popover-content w-32 popover-bottom-left")], [
        div([class("popover-arrow")], []),
        div([], [
          div(
            [
              class(
                "btn-group btn-group-vertical btn-group-scrollable w-full max-w-full",
              ),
            ],
            [
              html.button([class("btn w-full flex"), id("setLight")], [
                sun_medium([]),
                div([class("flex-1 text-center")], [html.text("Light")]),
              ]),
              html.button([class("btn w-full"), id("setDark")], [
                moon([]),
                div([class("flex-1 text-center")], [html.text("Dark")]),
              ]),
              html.button([class("btn w-full"), id("setSystem")], [
                laptop([]),
                div([class("flex-1 text-right")], [html.text("System")]),
              ]),
            ],
          ),
        ]),
      ]),
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
