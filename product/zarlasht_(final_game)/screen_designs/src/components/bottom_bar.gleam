import components/lucide_lustre.{github}
import components/theme_switch.{theme_switch}
import gleam/string.{join}
import lustre/attribute.{attribute, class, href, id, rel, src, style, target}
import lustre/element.{fragment}
import lustre/element/html.{a, button, div, img, label, p, text}
import lustre/element/svg

pub fn bottom_bar() {
  fragment([
    html.div(
      [
        attribute.id("BottomBar"),
        class("!fixed !bottom-[1.5rem]"),
        style([#("width", "calc(100% - 2rem)")]),
      ],
      [
        html.div(
          [
            attribute.class(join(
              [
                "!flex !rounded-full !ml-[0.5rem] !mr-[0.5rem]",
                "!items-center !justify-between !py-2 !px-2",
                "!bg-black/10 !border !border-black/15",
                "!dark:bg-white/15 !dark:border-white/15",
                "!backdrop-blur-[6px]",
                "!dark:shadow-[0px_10px_10px_-8px_rgba(18,18,23,0.02),0px_2px_2px_-1.5px_rgba(18,18,23,0.02),0px_1px_1px_-0.5px_rgba(18,18,23,0.02)]",
                "!shadow-[0px_10px_10px_-8px_rgba(237,237,232,0.02),0px_2px_2px_-1.5px_rgba(237,237,232,0.02),0px_1px_1px_-0.5px_rgba(237,237,232,0.02)]",
                "!transition-all !duration-500",
              ],
              " ",
            )),
          ],
          [
            html.div(
              [
                attribute.class(
                  "btn-group btn-group-rounded btn-group-scrollable",
                ),
              ],
              [theme_switch(), info_modal()],
            ),
            html.div(
              [
                attribute.class(
                  "btn-group btn-group-rounded btn-group-scrollable",
                ),
              ],
              [
                html.button(
                  [
                    attribute.class(join(
                      [
                        "btn border lg:inline-flex",
                        "bg-black/15 hover:bg-black/30",
                        "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                        "border-black/40 text-current",
                        "transition-all duration-500",
                      ],
                      " ",
                    )),
                  ],
                  [html.text("Create a Game")],
                ),
                html.button(
                  [
                    attribute.class(join(
                      [
                        "btn border lg:inline-flex",
                        "bg-black/15 hover:bg-black/30",
                        "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                        "border-black/40 text-current",
                        "transition-all duration-500",
                      ],
                      " ",
                    )),
                  ],
                  [html.text("Join a Game")],
                ),
              ],
            ),
            html.div([attribute.class("w-96 flex justify-end")], [
              html.div(
                [
                  attribute.class(
                    "btn-group btn-group-rounded btn-group-scrollable",
                  ),
                ],
                [
                  html.button(
                    [
                      attribute.class(join(
                        [
                          "btn border lg:inline-flex",
                          "bg-black/15 hover:bg-black/30",
                          "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                          "border-black/40 text-current",
                          "transition-all duration-500",
                        ],
                        " ",
                      )),
                    ],
                    [html.text("Create a Game")],
                  ),
                  html.button(
                    [
                      attribute.class(join(
                        [
                          "btn border lg:inline-flex",
                          "bg-black/15 hover:bg-black/30",
                          "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
                          "border-black/40 text-current",
                          "transition-all duration-500",
                        ],
                        " ",
                      )),
                    ],
                    [html.text("Join a Game")],
                  ),
                ],
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
}

fn info_modal() {
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
        [html.text("Open Modal")],
      ),
      html.div(
        [
          attribute("aria-labelledby", "InformationModal"),
          attribute("aria-modal", "true"),
          attribute.role("dialog"),
          attribute.class(
            "fixed inset-0 z-30 flex items-end justify-start bg-black/20 p-4 pb-8 backdrop-blur-md  lg:p-8 h-screen w-screen left-0 -top-[50vh]",
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
                  html.h3(
                    [
                      attribute.class(
                        "font-semibold tracking-wide text-neutral-900 dark:text-white",
                      ),
                      attribute.id("defaultModalTitle"),
                    ],
                    [html.text("Special Offer")],
                  ),
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
                  label([class("m-4 ")], [
                    p([], [
                      text("Created by "),
                      a(
                        [
                          class("text-green-8"),
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
              html.div([attribute.class("px-4 py-8")], [
                html.p([], [
                  html.text(
                    "As a token of appreciation, we have an exclusive offer just for you. Upgrade your account now to unlock premium features and enjoy a seamless experience.",
                  ),
                ]),
              ]),
              html.div(
                [
                  attribute.class(
                    "flex flex-col-reverse justify-between gap-2 border-t border-neutral-300 bg-neutral-50/60 p-4 dark:border-neutral-700 dark:bg-neutral-950/20 sm:flex-row sm:items-center md:justify-end",
                  ),
                ],
                [
                  html.button(
                    [
                      attribute.class(
                        "whitespace-nowrap rounded-sm px-4 py-2 text-center text-sm font-medium tracking-wide text-neutral-600 transition hover:opacity-75 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 dark:text-neutral-300 dark:focus-visible:outline-white",
                      ),
                      attribute.type_("button"),
                      attribute("x-on:click", "modalIsOpen = false"),
                    ],
                    [html.text("Remind me later")],
                  ),
                  html.button(
                    [
                      attribute.class(
                        "whitespace-nowrap rounded-sm bg-black border border-black dark:border-white px-4 py-2 text-center text-sm font-medium tracking-wide text-neutral-100 transition hover:opacity-75 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 dark:bg-white dark:text-black dark:focus-visible:outline-white",
                      ),
                      attribute.type_("button"),
                      attribute("x-on:click", "modalIsOpen = false"),
                    ],
                    [html.text("Upgrade Now")],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ]),
  ])
}
