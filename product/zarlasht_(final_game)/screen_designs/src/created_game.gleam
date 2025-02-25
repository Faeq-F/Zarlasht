import components/bottom_bar.{bottom_bar}
import lustre/attribute.{attribute, class, id, name, style, type_, value}
import lustre/element.{type Element, fragment}
import lustre/element/html.{
  button, div, form, input, li, p, script, span, text, ul,
}

pub fn created_game() -> Element(t) {
  div(
    [
      class("!text-left !absolute"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full")], [
        bottom_bar("created_game"),
        p([class(" !text-7xl text-center !mt-4 !text-teal-500 font-header")], [
          text("3978"),
        ]),
        p([class("!text-2xl text-center font-subheader")], [
          text("Share this code with friends!"),
        ]),
        div([class("game-container")], [
          ul([class("!grid"), id("player-container")], [
            form([class("row")], [
              li([class("!item")], [text("name1")]),
              li([class("!item")], [text("name2")]),
              li([class("!item")], [text("name3")]),
              li([class("!item")], [text("name4")]),
              li([class("!item")], [text("name5")]),
              li([class("!item")], [text("name6")]),
              li([class("!item")], [text("name7")]),
              li([class("!item")], [text("name8")]),
              li([class("!item")], [text("name9")]),
              li([class("!item")], [text("name10")]),
              li([class("!item")], [text("name11")]),
              li([class("!item")], [text("name12")]),
              li([class("!item")], [text("name13")]),
              li([class("!item")], [text("name14")]),
              li([class("!item")], [text("name15")]),
            ]),
            form(
              [
                attribute("hx-trigger", "end"),
                attribute("hx-post", "/items"),
                class("sortable  !row"),
              ],
              [
                div([], [input([value("1"), name("item"), type_("hidden")])]),
                div([], [input([value("2"), name("item"), type_("hidden")])]),
                div([], [input([value("3"), name("item"), type_("hidden")])]),
                div([], [input([value("4"), name("item"), type_("hidden")])]),
                div([], [input([value("5"), name("item"), type_("hidden")])]),
                div([], [input([value("1"), name("item"), type_("hidden")])]),
                div([], [input([value("2"), name("item"), type_("hidden")])]),
                div([], [input([value("3"), name("item"), type_("hidden")])]),
                div([], [input([value("4"), name("item"), type_("hidden")])]),
                div([], [input([value("5"), name("item"), type_("hidden")])]),
                div([], [input([value("1"), name("item"), type_("hidden")])]),
                div([], [input([value("2"), name("item"), type_("hidden")])]),
                div([], [input([value("3"), name("item"), type_("hidden")])]),
                div([], [input([value("4"), name("item"), type_("hidden")])]),
                div([], [input([value("5"), name("item"), type_("hidden")])]),
              ],
            ),
          ]),
        ]),
        script(
          [],
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
  ",
        ),
      ]),
    ],
  )
}
