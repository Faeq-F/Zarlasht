import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg

pub fn layout(app: Element(t)) {
  html.html([attribute("data-theme", "emerald"), attribute("lang", "en")], [
    html.head([], [
      html.title([], "ZARLASHT"),
      html.meta([
        attribute("content", "width=device-width, initial-scale=1"),
        attribute.name("viewport"),
      ]),
      html.link([
        attribute.rel("icon"),
        attribute.type_("image/x-icon"),
        attribute.href("./static/favicon.png"),
      ]),
      html.link([
        attribute.rel("preconnect"),
        attribute.href("https://fonts.googleapis.com"),
      ]),
      html.link([
        attribute.rel("preconnect"),
        attribute.href("https://fonts.gstatic.com"),
        attribute("crossorigin", ""),
      ]),
      html.link([
        attribute.href(
          "https://fonts.googleapis.com/css2?family=Varela+Round&display=swap",
        ),
        attribute.rel("stylesheet"),
      ]),
      html.link([
        attribute.href("./static/app.css"),
        attribute.rel("stylesheet"),
      ]),
      html.script([attribute.src("./static/libraries/tailwind.min.js")], ""),
      html.link([
        attribute.href("./static/libraries/daisyui.min.css"),
        attribute.rel("stylesheet"),
      ]),
      html.style(
        [attribute.type_("text/tailwindcss")],
        "
    .btn {
            @apply rounded-full;
          }
  ",
      ),
      html.script(
        [],
        "
    tailwind.config = {
      daisyui: {
        darkTheme: 'forest',
      }
    }

    window.onload = () => {
      const body = document.getElementsByTagName(\"body\")[0];
      const themeController = document.getElementsByClassName(\"theme-controller\")[0];
      themeController.addEventListener(\"click\", () => {
        if (body.classList.contains(\"dark\")) {
          body.classList.remove(\"dark\")
        } else {
          body.classList.add(\"dark\")
        }
      })
    }
  ",
      ),
    ]),
    html.body([], [
      html.div([attribute.id("bg")], []),
      html.label([attribute.class("swap swap-rotate right-0 fixed m-4 z-10")], [
        html.input([
          attribute.type_("checkbox"),
          attribute.class("theme-controller hidden"),
          attribute.value("forest"),
        ]),
        svg.svg(
          [
            attribute("xmlns", "http://www.w3.org/2000/svg"),
            attribute("viewBox", "0 0 24 24"),
            attribute.class("swap-off h-10 w-10 fill-current"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z",
              ),
            ]),
          ],
        ),
        svg.svg(
          [
            attribute("xmlns", "http://www.w3.org/2000/svg"),
            attribute("viewBox", "0 0 24 24"),
            attribute.class("swap-on h-10 w-10 fill-current"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z",
              ),
            ]),
          ],
        ),
      ]),
      html.label([attribute.class("left-0 m-4 fixed z-10")], [
        html.a(
          [
            attribute.target("_blank"),
            attribute.rel("noopener noreferrer"),
            attribute.href("https://github.com/faeq-f/tic-tac-toe"),
          ],
          [
            svg.svg(
              [
                attribute("xmlns", "http://www.w3.org/2000/svg"),
                attribute("width", "24"),
                attribute("height", "24"),
                attribute("viewBox", "0 0 24 24"),
                attribute.class("fill-current"),
              ],
              [
                svg.path([
                  attribute(
                    "d",
                    "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z",
                  ),
                ]),
              ],
            ),
          ],
        ),
      ]),
      html.label([attribute.class("left-0 bottom-0 fixed m-4 z-10")], [
        html.button(
          [
            attribute.class(
              "btn bg-transparent hover:bg-transparent border-0 text-3xl font-header",
            ),
            attribute("onclick", "SiteInfo.showModal()"),
          ],
          [html.text("i")],
        ),
        html.dialog([attribute.class("modal"), attribute.id("SiteInfo")], [
          html.div([attribute.class("modal-box")], [
            html.h3([attribute.class("text-4xl font-bold font-header")], [
              html.text("Acknowledgments"),
            ]),
            html.div([attribute.class("text-2xl py-4")], [
              html.p([attribute.class("")], [
                html.text("Game created by "),
                html.a(
                  [
                    attribute.target("_blank"),
                    attribute.rel("noopener noreferrer"),
                    attribute.href("https://faeq-f.github.io/"),
                    attribute.class(
                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                    ),
                  ],
                  [html.text("Faeq")],
                ),
              ]),
              html.ul([attribute.class("tree ml-[-5rem]")], [
                html.li([], [
                  html.details([attribute("open", "")], [
                    html.summary([], [html.p([], [])]),
                    html.ul([], [
                      html.li([], [
                        html.details([attribute("open", "")], [
                          html.summary([], [html.text("Images")]),
                          html.ul([], [
                            html.li([], [
                              html.p([], [
                                html.a(
                                  [
                                    attribute.href(
                                      "https://unsplash.com/photos/a-black-and-white-photo-of-a-mountain-0QzFognB6bY",
                                    ),
                                    attribute.target("_blank"),
                                    attribute.rel("noopener noreferrer"),
                                    attribute.class(
                                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                                    ),
                                  ],
                                  [
                                    html.text(
                                      "Background
                              image",
                                    ),
                                  ],
                                ),
                                html.text("by "),
                                html.a(
                                  [
                                    attribute.href(
                                      "https://unsplash.com/@cameron_visuals",
                                    ),
                                    attribute.class(
                                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                                    ),
                                    attribute.target("_blank"),
                                    attribute.rel("noopener noreferrer"),
                                  ],
                                  [
                                    html.text(
                                      "Cameron
                              Mourot",
                                    ),
                                  ],
                                ),
                              ]),
                            ]),
                          ]),
                        ]),
                      ]),
                      html.li([], [
                        html.details([attribute("open", "")], [
                          html.summary([], [html.text("Fonts")]),
                          html.ul([], [
                            html.li([], [
                              html.p([], [
                                html.a(
                                  [
                                    attribute.href(
                                      "https://www.1001fonts.com/requiem-font.html",
                                    ),
                                    attribute.target("_blank"),
                                    attribute.rel("noopener noreferrer"),
                                    attribute.class(
                                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                                    ),
                                  ],
                                  [
                                    html.text(
                                      "Headers
                              font",
                                    ),
                                  ],
                                ),
                                html.text("by "),
                                html.a(
                                  [
                                    attribute.href(
                                      "https://www.1001fonts.com/users/chrisx/",
                                    ),
                                    attribute.class(
                                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                                    ),
                                    attribute.target("_blank"),
                                    attribute.rel("noopener noreferrer"),
                                  ],
                                  [
                                    html.text(
                                      "Chris
                              Hansen",
                                    ),
                                  ],
                                ),
                              ]),
                            ]),
                            html.li([], [
                              html.p([], [
                                html.a(
                                  [
                                    attribute.href(
                                      "https://www.1001fonts.com/chancery-cursive-font.html",
                                    ),
                                    attribute.target("_blank"),
                                    attribute.rel("noopener noreferrer"),
                                    attribute.class(
                                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                                    ),
                                  ],
                                  [
                                    html.text(
                                      "Text
                              font",
                                    ),
                                  ],
                                ),
                                html.text("by "),
                                html.a(
                                  [
                                    attribute.href(
                                      "https://www.1001fonts.com/users/digitalgraphiclabs/",
                                    ),
                                    attribute.class(
                                      "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                                    ),
                                    attribute.target("_blank"),
                                    attribute.rel("noopener noreferrer"),
                                  ],
                                  [
                                    html.text(
                                      "Digital
                              Graphic
                              Labs",
                                    ),
                                  ],
                                ),
                              ]),
                            ]),
                          ]),
                        ]),
                      ]),
                      html.li([], [
                        html.p([], [
                          html.text("Icons by "),
                          html.a(
                            [
                              attribute.target("_blank"),
                              attribute.rel("noopener noreferrer"),
                              attribute.class(
                                "pl-0.5 hover:text-secondary duration-700 text-neutral font-bold text-[1.6rem] dark:text-slate-400 ",
                              ),
                              attribute.href("https://fontawesome.com/"),
                            ],
                            [
                              html.text(
                                "Font
                        Awesome",
                              ),
                            ],
                          ),
                        ]),
                      ]),
                    ]),
                  ]),
                ]),
              ]),
            ]),
            html.div([attribute.class("modal-action")], [
              html.form([attribute.method("dialog")], [
                html.button(
                  [
                    attribute.class(
                      "text-2xl dark:hover:text-shadow  dark:text-slate-400 text-zinc-700 hover:text-secondary py-2 px-6 duration-700 font-bold  border-t border-b border-gray-600 rounded-lg bg-transparent",
                    ),
                  ],
                  [html.text("Close")],
                ),
              ]),
            ]),
          ]),
        ]),
      ]),
      app,
    ]),
  ])
}
