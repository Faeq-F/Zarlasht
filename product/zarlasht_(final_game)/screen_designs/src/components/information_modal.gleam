import components/lucide_lustre.{github, info}
import components/theme_switch.{theme_switch}
import gleam/string.{join}
import lustre/attribute.{attribute, class, href, id, rel, src, style, target}
import lustre/element.{fragment}
import lustre/element/html.{a, br, button, div, img, label, p, text}
import lustre/element/svg

pub fn info_modal() {
  fragment([
    html.div([attribute("x-data", "{modalIsOpen: false}")], [
      html.button(
        [
          attribute.class(
            "btn border rounded-full !rounded-l-none text-current transition-all duration-500",
          ),
          attribute.type_("button"),
          attribute("x-on:click", "modalIsOpen = true"),
        ],
        [info([])],
      ),
      html.div(
        [
          attribute("aria-labelledby", "InformationModal"),
          attribute("aria-modal", "true"),
          attribute.role("dialog"),
          attribute.class(
            "fixed inset-0 z-30 flex items-end justify-start bg-black/20 p-4 !pb-[7rem] backdrop-blur-md  lg:p-8 h-screen w-screen -left-[1.5rem] -top-[90vh]",
          ),
          attribute("x-on:click.self", "modalIsOpen = false"),
          attribute("x-on:keydown.esc.window", "modalIsOpen = false"),
          attribute("x-trap.inert.noscroll", "modalIsOpen"),
          attribute("x-transition.opacity.duration.200ms", ""),
          attribute("x-show", "modalIsOpen"),
          attribute("x-cloak", ""),
        ],
        [
          html.div(
            [
              attribute.class(
                "flex max-w-lg flex-col gap-4 overflow-hidden rounded-2xl border border-neutral-300 bg-white text-neutral-600 dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300",
              ),
              attribute("x-transition:enter-end", "opacity-100 translate-y-0"),
              attribute("x-transition:enter-start", "opacity-0 translate-y-8"),
              attribute(
                "x-transition:enter",
                "transition ease-out duration-200 delay-100 motion-reduce:transition-opacity",
              ),
              attribute("x-show", "modalIsOpen"),
            ],
            [
              html.div(
                [
                  attribute.class(
                    "flex items-center justify-between border-b border-neutral-300 bg-neutral-50/60 p-4 dark:border-neutral-700 dark:bg-neutral-950/20",
                  ),
                ],
                [
                  label([class(" m-4 ")], [
                    a(
                      [
                        href("https://github.com/faeq-f/zarlasht"),
                        rel("noopener noreferrer"),
                        target("_blank"),
                      ],
                      [github([])],
                    ),
                  ]),
                  label([class("m-4 font-subheader")], [
                    p([], [
                      text("Created by "),
                      a(
                        [
                          class("!text-teal-500"),
                          href("https://faeq-f.github.io/"),
                          rel("noopener noreferrer"),
                          target("_blank"),
                        ],
                        [text("Faeq")],
                      ),
                    ]),
                  ]),
                  html.button(
                    [
                      attribute("aria-label", "close modal"),
                      attribute("x-on:click", "modalIsOpen = false"),
                    ],
                    [
                      svg.svg(
                        [
                          attribute.class("w-5 h-5"),
                          attribute("stroke-width", "1.4"),
                          attribute("fill", "none"),
                          attribute("stroke", "currentColor"),
                          attribute("aria-hidden", "true"),
                          attribute("viewBox", "0 0 24 24"),
                          attribute("xmlns", "http://www.w3.org/2000/svg"),
                        ],
                        [
                          svg.path([
                            attribute("d", "M6 18L18 6M6 6l12 12"),
                            attribute("stroke-linejoin", "round"),
                            attribute("stroke-linecap", "round"),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              html.div([attribute.class("px-4 py-8 font-text")], [
                html.p([], [
                  text("IM Fell DW Pica font by "),
                  a(
                    [
                      class("!text-teal-500"),
                      href("https://fonts.google.com/specimen/IM+Fell+DW+Pica"),
                      rel("noopener noreferrer"),
                      target("_blank"),
                    ],
                    [text("Igino Marini")],
                  ),
                  br([]),
                  text("Requiem font by "),
                  a(
                    [
                      class("!text-teal-500"),
                      href("https://www.1001fonts.com/requiem-font.html"),
                      rel("noopener noreferrer"),
                      target("_blank"),
                    ],
                    [text("Chris Hansen")],
                  ),
                  br([]),
                  text("Background Image by "),
                  a(
                    [
                      class("!text-teal-500"),
                      href(
                        "https://unsplash.com/photos/a-black-and-white-photo-of-a-mountain-0QzFognB6bY",
                      ),
                      rel("noopener noreferrer"),
                      target("_blank"),
                    ],
                    [text("Cameron Mourot")],
                  ),
                  br([]),
                  a(
                    [
                      class("!text-teal-500"),
                      href("https://faeq-f.github.io"),
                      rel("noopener noreferrer"),
                      target("_blank"),
                    ],
                    [text("More information here")],
                  ),
                ]),
              ]),
            ],
          ),
        ],
      ),
    ]),
  ])
}
