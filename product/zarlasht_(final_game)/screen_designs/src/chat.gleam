import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg

pub fn chat() -> Element(t) {
  html.div([attribute.id("app")], [
    html.div(
      [attribute.class("hero bg-transparent min-h-full"), attribute.id("page")],
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
            html.div(
              [
                attribute.class(
                  "isolate p-12 rounded-xl dark:bg-black/40 bg-white/40 shadow-lg ring-1 ring-black/5",
                ),
              ],
              [
                html.div([attribute.class("container")], [
                  html.div([attribute.class("Name text-3xl font-header")], [
                    html.text("Allies"),
                  ]),
                  html.div([attribute.class("Chat-Button")], [
                    html.button(
                      [
                        attribute.class(
                          "w-full  text-shadow drop-shadow-xl text-accent hover:text-secondary hover:fill-[oklch(var(--s))] fill-[oklch(var(--a))] border-t border-b border-gray-600 rounded-lg duration-600",
                        ),
                      ],
                      [
                        svg.svg(
                          [
                            attribute.class("size-6  h-12 w-full mt-6"),
                            attribute("stroke", "currentColor"),
                            attribute("stroke-width", "1.5"),
                            attribute("viewBox", "0 0 24 24"),
                            attribute("fill", "none"),
                            attribute("xmlns", "http://www.w3.org/2000/svg"),
                          ],
                          [
                            svg.path([
                              attribute(
                                "d",
                                "M20.25 8.511c.884.284 1.5 1.128 1.5 2.097v4.286c0 1.136-.847 2.1-1.98 2.193-.34.027-.68.052-1.02.072v3.091l-3-3c-1.354 0-2.694-.055-4.02-.163a2.115 2.115 0 0 1-.825-.242m9.345-8.334a2.126 2.126 0 0 0-.476-.095 48.64 48.64 0 0 0-8.048 0c-1.131.094-1.976 1.057-1.976 2.192v4.286c0 .837.46 1.58 1.155 1.951m9.345-8.334V6.637c0-1.621-1.152-3.026-2.76-3.235A48.455 48.455 0 0 0 11.25 3c-2.115 0-4.198.137-6.24.402-1.608.209-2.76 1.614-2.76 3.235v6.226c0 1.621 1.152 3.026 2.76 3.235.577.075 1.157.14 1.74.194V21l4.155-4.155",
                              ),
                              attribute("stroke-linejoin", "round"),
                              attribute("stroke-linecap", "round"),
                            ]),
                          ],
                        ),
                        html.br([]),
                        html.p([attribute.class("text-2xl")], [
                          html.text("Chat"),
                        ]),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("Me pt-4")], [
                    html.button(
                      [
                        attribute.class(
                          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full ",
                        ),
                      ],
                      [
                        svg.svg(
                          [
                            attribute.class(
                              "size-6 h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl",
                            ),
                            attribute("stroke", "currentColor"),
                            attribute("stroke-width", "1.5"),
                            attribute("viewBox", "0 0 24 24"),
                            attribute("fill", "none"),
                            attribute("xmlns", "http://www.w3.org/2000/svg"),
                          ],
                          [
                            svg.path([
                              attribute(
                                "d",
                                "M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z",
                              ),
                              attribute("stroke-linejoin", "round"),
                              attribute("stroke-linecap", "round"),
                            ]),
                          ],
                        ),
                        html.br([]),
                        html.p([attribute.class("text-2xl")], [html.text("Me")]),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("Close pt-4")], [
                    html.button(
                      [
                        attribute.class(
                          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-error hover:fill-[oklch(var(--er))] border-t border-b border-gray-600 rounded-lg w-full",
                        ),
                      ],
                      [
                        svg.svg(
                          [
                            attribute.class(
                              " h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl size-6",
                            ),
                            attribute("stroke", "currentColor"),
                            attribute("stroke-width", "1.5"),
                            attribute("viewBox", "0 0 24 24"),
                            attribute("fill", "none"),
                            attribute("xmlns", "http://www.w3.org/2000/svg"),
                          ],
                          [
                            svg.path([
                              attribute("d", "M6 18 18 6M6 6l12 12"),
                              attribute("stroke-linejoin", "round"),
                              attribute("stroke-linecap", "round"),
                            ]),
                          ],
                        ),
                        html.br([]),
                        html.p([attribute.class("text-2xl")], [
                          html.text("Close"),
                        ]),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("Map pt-4")], [
                    html.button(
                      [
                        attribute.class(
                          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full",
                        ),
                      ],
                      [
                        svg.svg(
                          [
                            attribute.class(
                              "size-6 h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl",
                            ),
                            attribute("stroke", "currentColor"),
                            attribute("stroke-width", "1.5"),
                            attribute("viewBox", "0 0 24 24"),
                            attribute("fill", "none"),
                            attribute("xmlns", "http://www.w3.org/2000/svg"),
                          ],
                          [
                            svg.path([
                              attribute(
                                "d",
                                "M9 6.75V15m6-6v8.25m.503 3.498 4.875-2.437c.381-.19.622-.58.622-1.006V4.82c0-.836-.88-1.38-1.628-1.006l-3.869 1.934c-.317.159-.69.159-1.006 0L9.503 3.252a1.125 1.125 0 0 0-1.006 0L3.622 5.689C3.24 5.88 3 6.27 3 6.695V19.18c0 .836.88 1.38 1.628 1.006l3.869-1.934c.317-.159.69-.159 1.006 0l4.994 2.497c.317.158.69.158 1.006 0Z",
                              ),
                              attribute("stroke-linejoin", "round"),
                              attribute("stroke-linecap", "round"),
                            ]),
                          ],
                        ),
                        html.br([]),
                        html.p([attribute.class("text-2xl")], [html.text("Map")]),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("Roll-die pt-4")], [
                    html.button(
                      [
                        attribute.class(
                          " text-shadow  text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full",
                        ),
                      ],
                      [
                        svg.svg(
                          [
                            attribute.class(
                              "size-6 h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl",
                            ),
                            attribute("stroke", "currentColor"),
                            attribute("stroke-width", "1.5"),
                            attribute("viewBox", "0 0 24 24"),
                            attribute("fill", "none"),
                            attribute("xmlns", "http://www.w3.org/2000/svg"),
                          ],
                          [
                            svg.path([
                              attribute(
                                "d",
                                "M15.042 21.672 13.684 16.6m0 0-2.51 2.225.569-9.47 5.227 7.917-3.286-.672Zm-7.518-.267A8.25 8.25 0 1 1 20.25 10.5M8.288 14.212A5.25 5.25 0 1 1 17.25 10.5",
                              ),
                              attribute("stroke-linejoin", "round"),
                              attribute("stroke-linecap", "round"),
                            ]),
                          ],
                        ),
                        html.br([]),
                        html.p([attribute.class("text-2xl")], [
                          html.text("Roll die"),
                        ]),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("Chat overflowy-scroll")], [
                    html.div(
                      [
                        attribute.class(
                          "mx-12 px-2 overflow-y-scroll max-h-full h-full mt-10 border rounded-box border-gray-600",
                        ),
                      ],
                      [
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--p));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-primary text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-primary bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "What kind
                    of nonsense is this
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--s));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-secondary text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Picard
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-secondary bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "Put me on the Council and not make me a Master!??
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--a));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-accent text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Catherine Halsey
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-accent bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "That's never been done in the history of the Jedi. It's
                    insulting!
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--in));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-info text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Someone's name
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-info bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "Calm down,
                    Anakin.
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--su));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-success text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "John Doe
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-success bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "You have
                    been given a great honor.",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--wa));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-warning text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-warning bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "To be on
                    the Council at your age.
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--er));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header text-error text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-error bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "It's never
                    happened before.",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--p));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-primary text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-primary bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "What kind
                    of nonsense is this
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--s));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-secondary text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Picard
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-secondary bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "Put me on the Council and not make me a Master!??
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--a));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-accent text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Catherine Halsey
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-accent bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "That's never been done in the history of the Jedi. It's
                    insulting!
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--in));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-info text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Someone's name
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-info bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "Calm down,
                    Anakin.
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--su));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-success text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "John Doe
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-success bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "You have
                    been given a great honor.",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--wa));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-warning text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-warning bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "To be on
                    the Council at your age.
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--er));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header text-error text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-error bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "It's never
                    happened before.",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--p));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-primary text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-primary bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "What kind
                    of nonsense is this
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--s));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-secondary text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Picard
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-secondary bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "Put me on the Council and not make me a Master!??
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--a));",
                            ),
                            attribute.class("chat chat-start"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-accent text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Catherine Halsey
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-accent bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "That's never been done in the history of the Jedi. It's
                    insulting!
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--in));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-info text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Someone's name
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-info bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "Calm down,
                    Anakin.
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--su));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-success text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "John Doe
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-success bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "You have
                    been given a great honor.",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--wa));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header  text-warning text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-warning bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "To be on
                    the Council at your age.
                  ",
                                ),
                              ],
                            ),
                          ],
                        ),
                        html.div(
                          [
                            attribute(
                              "style",
                              "--chat-border-color: oklch(var(--er));",
                            ),
                            attribute.class("chat chat-end"),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "chat-header text-error text-shadow font-header",
                                ),
                              ],
                              [
                                html.text(
                                  "Obi-Wan Kenobi
                  ",
                                ),
                              ],
                            ),
                            html.div(
                              [
                                attribute.class(
                                  "chat-bubble border border-error bg-base-100 text-base-content text-lg",
                                ),
                              ],
                              [
                                html.text(
                                  "It's never
                    happened before.",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("message join mt-12 mx-12 ")], [
                    html.textarea(
                      [
                        attribute.placeholder("Your message..."),
                        attribute.class(
                          "textarea join-item textarea-bordered w-full h-full text-lg bg-transparent border-gray-600 rounded-xl",
                        ),
                      ],
                      "",
                    ),
                    html.button(
                      [
                        attribute.class(
                          "btn join-item bg-transparent h-full !rounded-tr-xl !rounded-br-xl hover:bg-transparent text-shadow text-success hover:text-accent",
                        ),
                      ],
                      [
                        html.span(
                          [attribute.class(" font-header text-4xl sendIcon  ")],
                          [html.text("L")],
                        ),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("Allies")], [
                    html.button(
                      [
                        attribute.class(
                          " text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary hover:fill-[oklch(var(--s))] fill-current border-t border-b border-gray-600 rounded-lg w-full",
                        ),
                      ],
                      [
                        svg.svg(
                          [
                            attribute.class(
                              " h-12 w-full mt-6 drop-shadow-xl-green hover:drop-shadow-xl size-6",
                            ),
                            attribute("stroke", "currentColor"),
                            attribute("stroke-width", "1.5"),
                            attribute("viewBox", "0 0 24 24"),
                            attribute("fill", "none"),
                            attribute("xmlns", "http://www.w3.org/2000/svg"),
                          ],
                          [
                            svg.path([
                              attribute(
                                "d",
                                "M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z",
                              ),
                              attribute("stroke-linejoin", "round"),
                              attribute("stroke-linecap", "round"),
                            ]),
                          ],
                        ),
                        html.br([]),
                        html.br([]),
                        html.p([attribute.class("text-2xl")], [
                          html.text("Allies"),
                        ]),
                      ],
                    ),
                  ]),
                  html.div([attribute.class("people")], [
                    html.details([attribute.class("dropdown")], [
                      html.summary(
                        [
                          attribute.class(
                            "mt-4 px-6 border-0 !border-l !border-r border-gray-600 rounded-lg w-full btn mb-1 bg-transparent hover:bg-transparent text-secondary-content hover:text-shadow text-shadow-green hover:text-secondary  w-full text-2xl",
                          ),
                        ],
                        [
                          html.text(
                            "Direct
                  Message
                ",
                          ),
                        ],
                      ),
                      html.ul(
                        [
                          attribute.class(
                            "bg-transparent rounded-box z-[1] p-2 border border-black max-w-full overflow-y-scroll max-h-96 rounded-tr-none rounded-tl-none",
                          ),
                          attribute.id("people-popup"),
                        ],
                        [
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                          html.li([attribute.class("w-full")], [
                            html.button(
                              [
                                attribute.class(
                                  "btn join-item bg-transparent hover:bg-transparent hover:text-secondary hover:text-shadow rounded-r-full h-full border-none text-lg",
                                ),
                              ],
                              [html.span([], [html.text("Person 1")])],
                            ),
                          ]),
                        ],
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          ],
        ),
      ],
    ),
  ])
}
