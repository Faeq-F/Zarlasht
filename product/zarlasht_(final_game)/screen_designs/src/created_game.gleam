import lustre/attribute.{attribute}
import lustre/element.{type Element, fragment}
import lustre/element/html

pub fn created_game() -> Element(t) {
  fragment([
    html.div([attribute.id("app")], [
      html.div(
        [
          attribute.class("hero bg-transparent min-h-full"),
          attribute.id("page"),
        ],
        [
          html.h1([attribute.class("text-5xl mt-4 font-header")], [
            html.text("ZARLASHT"),
          ]),
          html.div(
            [
              attribute.class(
                "hero-content text-center absolute top-1/2 -translate-y-1/2 ",
              ),
            ],
            [
              html.div([], [
                html.p(
                  [attribute.class(" text-7xl text-success mx-auto my-0")],
                  [
                    html.text(
                      "3978
          ",
                    ),
                  ],
                ),
                html.p([attribute.class(" text-2xl")], [
                  html.text(
                    "Share this code with friends!
          ",
                  ),
                ]),
                html.div([attribute.class("game-container")], [
                  html.ul(
                    [attribute.class("grid"), attribute.id("player-container")],
                    [
                      html.form([attribute.class("row")], [
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                        html.li([attribute.class("item")], [html.text("test")]),
                      ]),
                      html.form(
                        [
                          attribute("hx-trigger", "end"),
                          attribute("hx-post", "/items"),
                          attribute.class("sortable  row"),
                        ],
                        [
                          html.div([], [
                            html.input([
                              attribute.value("1"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("2"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("3"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("4"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("5"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("1"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("2"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("3"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("4"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("5"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("1"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("2"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("3"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("4"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                          html.div([], [
                            html.input([
                              attribute.value("5"),
                              attribute.name("item"),
                              attribute.type_("hidden"),
                            ]),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ]),
                html.p([attribute.class(" text-xl")], [
                  html.text(
                    "(minimum of 5 players)
          ",
                  ),
                ]),
                html.button(
                  [
                    attribute.class(
                      "btn join-item bg-transparent hover:bg-transparent border-0  text-secondary-content hover:text-secondary text-xl hover:text-shadow ",
                    ),
                    attribute.id("startButton"),
                    attribute("data-theme", "forest"),
                  ],
                  [html.span([], [html.text("Start Game")])],
                ),
              ]),
            ],
          ),
        ],
      ),
    ]),
    html.script(
      [],
      "
    // htmx.onLoad(function (content) {
    //var sortables = content.querySelectorAll(\".sortable\");
    var sortables = document.querySelectorAll(\".sortable\");
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
    // })
  ",
    ),
  ])
}
