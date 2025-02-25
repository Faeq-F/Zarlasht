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
        script(
          [],
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
