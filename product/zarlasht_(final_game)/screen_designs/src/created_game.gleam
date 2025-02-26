import components/bottom_bar.{bottom_bar}
import components/lucide_lustre.{copy}
import gleam/int
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, name, style, type_, value}
import lustre/element.{type Element}
import lustre/element/html.{
  button, div, form, input, label, li, p, script, text, ul,
}

pub fn created_game() -> Element(t) {
  div(
    [
      class("!text-left !absolute"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full")], [
        bottom_bar(info(), buttons(3978)),
        p([class(" !text-7xl text-center !mt-4 !text-teal-500 font-header")], [
          text("3978"),
        ]),
        p([class("!text-2xl text-center font-subheader")], [
          text("Share this code with friends!"),
        ]),
        div([class("game-container"), style([#("cursor", "grab")])], [
          ul([class("!grid"), id("player-container")], [
            form([class("row")], [
              li([class("item text-center font-subheader")], [text("Faeq")]),
              li([class("item text-center font-subheader")], [text("Mubz")]),
              li([class("item text-center font-subheader")], [text("Mahid")]),
              li([class("item text-center font-subheader")], [text("Dennis")]),
              li([class("item text-center font-subheader")], [text("Hossam")]),
              li([class("item text-center font-subheader")], [text("Faeq2")]),
              li([class("item text-center font-subheader")], [text("Mubz2")]),
              li([class("item text-center font-subheader")], [text("Mahid2")]),
              li([class("item text-center font-subheader")], [text("Dennis2")]),
              li([class("item text-center font-subheader")], [text("Hossam2")]),
              li([class("item text-center font-subheader")], [text("Faeq3")]),
              li([class("item text-center font-subheader")], [text("Mubz3")]),
              li([class("item text-center font-subheader")], [text("Mahid3")]),
              li([class("item text-center font-subheader")], [text("Dennis3")]),
              li([class("item text-center font-subheader")], [text("Hossam3")]),
            ]),
            form(
              [
                attribute("hx-trigger", "end"),
                attribute("hx-post", "/items"),
                class("sortable  !row"),
              ],
              [
                div([class("bg-red-500/20")], [
                  input([value("1"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-orange-500/20")], [
                  input([value("2"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-amber-500/20")], [
                  input([value("3"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-yellow-500/20")], [
                  input([value("4"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-lime-500/20")], [
                  input([value("5"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-green-500/20")], [
                  input([value("1"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-emerald-500/20")], [
                  input([value("2"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-teal-500/20")], [
                  input([value("3"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-cyan-500/20")], [
                  input([value("4"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-sky-500/20")], [
                  input([value("5"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-blue-500/20")], [
                  input([value("1"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-indigo-500/20")], [
                  input([value("2"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-violet-500/20")], [
                  input([value("3"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-purple-500/20")], [
                  input([value("4"), name("item"), type_("hidden")]),
                ]),
                div([class("bg-fuchsia-500/20")], [
                  input([value("5"), name("item"), type_("hidden")]),
                ]),
              ],
            ),
          ]),
        ]),
        script([], page_script()),
      ]),
    ],
  )
}

fn info() {
  div(
    [
      class("btn !bg-gray-100 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("minimum of 5 players")],
  )
}

fn buttons(game_code) {
  [
    div([class("popover popover-border contents")], [
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
          attribute("tabindex", "0"),
          attribute(
            "@click",
            "navigator.clipboard.writeText(\""
              <> int.to_string(game_code)
              <> "\")",
          ),
        ],
        [copy([])],
      ),
      div(
        [
          class(
            "popover-content w-32 popover-top-left !fixed font-text !bg-green-300",
          ),
          attribute("tabindex", "0"),
          style([#("width", "fit-content")]),
        ],
        [div([], [text("Copied game code")])],
      ),
    ]),
    button([class(join(["btn !rounded-r-full font-text !text-xl"], " "))], [
      text("Start Game"),
    ]),
  ]
}

fn page_script() {
  let drag_scroll =
    "
    let mouseDown = false;
    let startX, scrollLeft;
    const slider = document.querySelector('.game-container');

    const startDragging = (e) => {
      mouseDown = true;
      startX = e.pageX - slider.offsetLeft;
      scrollLeft = slider.scrollLeft;
    }

    const stopDragging = (e) => {
      mouseDown = false;
    }

    const move = (e) => {
      e.preventDefault();
      if(!mouseDown) { return; }
      const x = e.pageX - slider.offsetLeft;
      const scroll = x - startX;
      slider.scrollLeft = scrollLeft - scroll;
    }

    // Add the event listeners
    slider.addEventListener('mousemove', move, false);
    slider.addEventListener('mousedown', startDragging, false);
    slider.addEventListener('mouseup', stopDragging, false);
    slider.addEventListener('mouseleave', stopDragging, false);
    "

  let sortable_colors =
    "
    htmx.onLoad(function (content) {
    var sortables = content.querySelectorAll(\".sortable\");
    for (var i = 0; i < sortables.length; i++) {
      var sortable = sortables[i];
      var sortableInstance = new Sortable(sortable, {
        animation: 150,
        axis: 'horizontal',
        ghostClass: 'blue-background-class',

        // Make the `.htmx-indicator` unsortable
        filter: \".htmx-indicator\",
        onMove: function (evt) {
          return evt.related.className.indexOf('htmx-indicator') === -1;
        },
      });

      // Re-enable sorting on the `htmx:afterSwap` event
      sortable.addEventListener(\"htmx:afterSwap\", function () {
        sortableInstance.option(\"disabled\", false);
      });
    }
    })
    "
  drag_scroll <> sortable_colors
}
