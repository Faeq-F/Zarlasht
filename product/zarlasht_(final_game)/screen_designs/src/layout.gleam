//// Layout for all pages the site renders

import components/lucide_lustre.{github, moon, sun}
import components/theme_switch.{theme_switch}
import gleam/list
import lustre/attribute.{
  attribute, class, href, id, name, rel, src, style, target, type_,
}
import lustre/element.{type Element}
import lustre/element/html.{
  a, body, div, head, html, img, label, link, meta, p, script, text, title,
}

import lustre/element/svg

/// Layout for all pages the site renders
///
/// The elements provided are placed in a DIV element with the ID `page`
///
pub fn layout(elements: List(Element(t))) -> Element(t) {
  html([attribute("lang", "en"), attribute("data-theme", "emerald")], [
    head([], [
      title([], "Zarlasht"),
      meta([
        name("viewport"),
        attribute("content", "width=device-width, initial-scale=1"),
      ]),
      link([href("/static/favicon.png"), type_("image/x-icon"), rel("icon")]),
      link([rel("stylesheet"), href("/static/app.css")]),
      script([src("/static/libraries/sortable.min.js")], ""),
      script([src("/static/libraries/htmx.min.js")], ""),
      script([src("/static/libraries/htmx-ext/ws.js")], ""),
      script(
        [src("/static/libraries/alpine.focus.min.js"), attribute("defer", "")],
        "",
      ),
      script(
        [src("/static/libraries/alpine.min.js"), attribute("defer", "")],
        "",
      ),
      script([src("/static/libraries/tailwind.min.js")], ""),
      link([
        href("https://cdn.jsdelivr.net/npm/rippleui/dist/css/styles.css"),
        rel("stylesheet"),
      ]),
      link([rel("stylesheet"), href("/static/app.css")]),
      html.style(
        [attribute.type_("text/tailwindcss")],
        "
        @variant dark (&:where(.dark, .dark *));
    ",
      ),
    ]),
    body([], [
      div(
        [
          attribute("ws-connect", "/init_socket"),
          attribute("hx-ext", "ws"),
          id("app"),
        ],
        [
          script([], "window.onbeforeunload = function() {return true;};"),
          div([id("page"), class("h-full w-full")], elements),
        ],
      ),
      div(
        [id("fogWrap"), class("fogWrap")],
        list.repeat(img([src("/static/cloud.png")]), 100),
      ),
      html.style(
        [attribute("lang", "scss")],
        "
@use 'sass:math';

$bgAnimation: 100;

@for $i from 1 through $bgAnimation {
  $scale: math.random(2) - 0.4;

  .fogWrap img:nth-child(#{$i}) {
    left: math.random(120) * 1% - 20;
    animation: raise#{$i} 7 + math.random(15) + s linear infinite;
    animation-delay: math.random(5) - 5 + s;
    transform: scale(0.3 * $i - 0.6) rotate(math.random(360) + deg);
    z-index: $i + 99;

    @keyframes raise#{$i} {
      to {
        bottom: 150vh;
        transform: scale(0.3 * $i - 0.6) rotate(math.random(360) + deg);
      }
    }
  }
}

",
      ),
      script(
        [type_("module")],
        "const sass = await import('https://jspm.dev/sass');
        sass.compileString(document.querySelector(\"style[lang=scss]\").innerHTML);",
      ),
      notifications(),
    ]),
  ])
}

fn notifications() {
  html.div(
    [
      attribute(
        "x-on:notify.window",
        "addNotification({
            variant: $event.detail.variant,
            sender: $event.detail.sender,
            title: $event.detail.title,
            message: $event.detail.message,
        })",
      ),
      attribute(
        "x-data",
        "{
        notifications: [],
        displayDuration: 8000,
        soundEffect: false,

        addNotification({ variant = 'info', sender = null, title = null, message = null}) {
            const id = Date.now()
            const notification = { id, variant, sender, title, message }

            // Keep only the most recent 20 notifications
            if (this.notifications.length >= 20) {
                this.notifications.splice(0, this.notifications.length - 19)
            }

            // Add the new notification to the notifications stack
            this.notifications.push(notification)

            if (this.soundEffect) {
                // Play the notification sound
                const notificationSound = new Audio('https://res.cloudinary.com/ds8pgw1pf/video/upload/v1728571480/penguinui/component-assets/sounds/ding.mp3')
                notificationSound.play().catch((error) => {
                    console.error('Error playing the sound:', error)
                })
            }
        },
        removeNotification(id) {
            setTimeout(() => {
                this.notifications = this.notifications.filter(
                    (notification) => notification.id !== id,
                )
            }, 400);
        },
    }",
      ),
    ],
    [
      html.div(
        [
          attribute.class(
            "group pointer-events-none fixed inset-x-8 top-0 z-99 flex max-w-full flex-col gap-2 bg-transparent px-6 py-6 md:bottom-0 md:left-[unset] md:right-0 md:top-[unset] md:max-w-sm",
          ),
          attribute("x-on:mouseleave", "$dispatch('resume-auto-dismiss')"),
          attribute("x-on:mouseenter", "$dispatch('pause-auto-dismiss')"),
        ],
        [
          html.template(
            [
              attribute("x-bind:key", "notification.id"),
              attribute("x-for", "(notification, index) in notifications"),
            ],
            [
              html.div([], [
                html.template(
                  [attribute("x-if", "notification.variant === 'info'")],
                  [
                    html.div(
                      [
                        attribute(
                          "x-transition:leave-start",
                          "translate-x-0 opacity-100",
                        ),
                        attribute(
                          "x-transition:leave-end",
                          "-translate-x-24 opacity-0 md:translate-x-24",
                        ),
                        attribute(
                          "x-transition:leave",
                          "transition duration-300 ease-in",
                        ),
                        attribute("x-transition:enter-start", "translate-y-8"),
                        attribute("x-transition:enter-end", "translate-y-0"),
                        attribute(
                          "x-transition:enter",
                          "transition duration-300 ease-out",
                        ),
                        attribute(
                          "x-init",
                          "$nextTick(() => { isVisible = true }), (timeout = setTimeout(() => { isVisible = false, removeNotification(notification.id)}, displayDuration))",
                        ),
                        attribute(
                          "x-on:resume-auto-dismiss.window",
                          " timeout = setTimeout(() => {(isVisible = false), removeNotification(notification.id) }, displayDuration)",
                        ),
                        attribute(
                          "x-on:pause-auto-dismiss.window",
                          "clearTimeout(timeout)",
                        ),
                        attribute.role("alert"),
                        attribute.class(
                          "pointer-events-auto relative rounded-sm border border-sky-500 bg-white text-neutral-600 dark:bg-neutral-950 dark:text-neutral-300",
                        ),
                        attribute("x-show", "isVisible"),
                        attribute("x-cloak", ""),
                        attribute(
                          "x-data",
                          "{ isVisible: false, timeout: null }",
                        ),
                      ],
                      [
                        html.div(
                          [
                            attribute.class(
                              "flex w-full items-center gap-2.5 bg-sky-500/10 rounded-sm p-4 transition-all duration-300",
                            ),
                          ],
                          [
                            html.div(
                              [
                                attribute("aria-hidden", "true"),
                                attribute.class(
                                  "rounded-full bg-sky-500/15 p-0.5 text-sky-500",
                                ),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5"),
                                    attribute("fill", "currentColor"),
                                    attribute("viewBox", "0 0 20 20"),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg",
                                    ),
                                  ],
                                  [
                                    svg.path([
                                      attribute("clip-rule", "evenodd"),
                                      attribute(
                                        "d",
                                        "M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-7-4a1 1 0 1 1-2 0 1 1 0 0 1 2 0ZM9 9a.75.75 0 0 0 0 1.5h.253a.25.25 0 0 1 .244.304l-.459 2.066A1.75 1.75 0 0 0 10.747 15H11a.75.75 0 0 0 0-1.5h-.253a.25.25 0 0 1-.244-.304l.459-2.066A1.75 1.75 0 0 0 9.253 9H9Z",
                                      ),
                                      attribute("fill-rule", "evenodd"),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                            html.div([attribute.class("flex flex-col gap-2")], [
                              html.h3(
                                [
                                  attribute("x-text", "notification.title"),
                                  attribute.class(
                                    "text-sm font-semibold text-sky-500",
                                  ),
                                  attribute("x-show", "notification.title"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                              html.p(
                                [
                                  attribute("x-text", "notification.message"),
                                  attribute.class("text-pretty text-sm"),
                                  attribute("x-show", "notification.message"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                            ]),
                            html.button(
                              [
                                attribute(
                                  "x-on:click",
                                  "(isVisible = false), removeNotification(notification.id)",
                                ),
                                attribute("aria-label", "dismiss notification"),
                                attribute.class("ml-auto"),
                                attribute.type_("button"),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5 shrink-0"),
                                    attribute("stroke-width", "2"),
                                    attribute("fill", "none"),
                                    attribute("stroke", "currentColor"),
                                    attribute("24", ""),
                                    attribute("0", ""),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg viewBox=",
                                    ),
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
                      ],
                    ),
                  ],
                ),
                html.template(
                  [attribute("x-if", "notification.variant === 'success'")],
                  [
                    html.div(
                      [
                        attribute(
                          "x-transition:leave-start",
                          "translate-x-0 opacity-100",
                        ),
                        attribute(
                          "x-transition:leave-end",
                          "-translate-x-24 opacity-0 md:translate-x-24",
                        ),
                        attribute(
                          "x-transition:leave",
                          "transition duration-300 ease-in",
                        ),
                        attribute("x-transition:enter-start", "translate-y-8"),
                        attribute("x-transition:enter-end", "translate-y-0"),
                        attribute(
                          "x-transition:enter",
                          "transition duration-300 ease-out",
                        ),
                        attribute(
                          "x-init",
                          "$nextTick(() => { isVisible = true }), (timeout = setTimeout(() => { isVisible = false, removeNotification(notification.id)}, displayDuration))",
                        ),
                        attribute(
                          "x-on:resume-auto-dismiss.window",
                          " timeout = setTimeout(() => {(isVisible = false), removeNotification(notification.id) }, displayDuration)",
                        ),
                        attribute(
                          "x-on:pause-auto-dismiss.window",
                          "clearTimeout(timeout)",
                        ),
                        attribute.role("alert"),
                        attribute.class(
                          "pointer-events-auto relative rounded-sm border border-green-500 bg-white text-neutral-600 dark:bg-neutral-950 dark:text-neutral-300",
                        ),
                        attribute("x-show", "isVisible"),
                        attribute("x-cloak", ""),
                        attribute(
                          "x-data",
                          "{ isVisible: false, timeout: null }",
                        ),
                      ],
                      [
                        html.div(
                          [
                            attribute.class(
                              "flex w-full items-center gap-2.5 bg-green-500/10 rounded-sm p-4 transition-all duration-300",
                            ),
                          ],
                          [
                            html.div(
                              [
                                attribute("aria-hidden", "true"),
                                attribute.class(
                                  "rounded-full bg-green-500/15 p-0.5 text-green-500",
                                ),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5"),
                                    attribute("fill", "currentColor"),
                                    attribute("viewBox", "0 0 20 20"),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg",
                                    ),
                                  ],
                                  [
                                    svg.path([
                                      attribute("clip-rule", "evenodd"),
                                      attribute(
                                        "d",
                                        "M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z",
                                      ),
                                      attribute("fill-rule", "evenodd"),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                            html.div([attribute.class("flex flex-col gap-2")], [
                              html.h3(
                                [
                                  attribute("x-text", "notification.title"),
                                  attribute.class(
                                    "text-sm font-semibold text-green-500",
                                  ),
                                  attribute("x-show", "notification.title"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                              html.p(
                                [
                                  attribute("x-text", "notification.message"),
                                  attribute.class("text-pretty text-sm"),
                                  attribute("x-show", "notification.message"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                            ]),
                            html.button(
                              [
                                attribute(
                                  "x-on:click",
                                  "(isVisible = false), removeNotification(notification.id)",
                                ),
                                attribute("aria-label", "dismiss notification"),
                                attribute.class("ml-auto"),
                                attribute.type_("button"),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5 shrink-0"),
                                    attribute("stroke-width", "2"),
                                    attribute("fill", "none"),
                                    attribute("stroke", "currentColor"),
                                    attribute("24", ""),
                                    attribute("0", ""),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg viewBox=",
                                    ),
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
                      ],
                    ),
                  ],
                ),
                html.template(
                  [attribute("x-if", "notification.variant === 'warning'")],
                  [
                    html.div(
                      [
                        attribute(
                          "x-transition:leave-start",
                          "translate-x-0 opacity-100",
                        ),
                        attribute(
                          "x-transition:leave-end",
                          "-translate-x-24 opacity-0 md:translate-x-24",
                        ),
                        attribute(
                          "x-transition:leave",
                          "transition duration-300 ease-in",
                        ),
                        attribute("x-transition:enter-start", "translate-y-8"),
                        attribute("x-transition:enter-end", "translate-y-0"),
                        attribute(
                          "x-transition:enter",
                          "transition duration-300 ease-out",
                        ),
                        attribute(
                          "x-init",
                          "$nextTick(() => { isVisible = true }), (timeout = setTimeout(() => { isVisible = false, removeNotification(notification.id)}, displayDuration))",
                        ),
                        attribute(
                          "x-on:resume-auto-dismiss.window",
                          " timeout = setTimeout(() => {(isVisible = false), removeNotification(notification.id) }, displayDuration)",
                        ),
                        attribute(
                          "x-on:pause-auto-dismiss.window",
                          "clearTimeout(timeout)",
                        ),
                        attribute.role("alert"),
                        attribute.class(
                          "pointer-events-auto relative rounded-sm border border-amber-500 bg-white text-neutral-600 dark:bg-neutral-950 dark:text-neutral-300",
                        ),
                        attribute("x-show", "isVisible"),
                        attribute("x-cloak", ""),
                        attribute(
                          "x-data",
                          "{ isVisible: false, timeout: null }",
                        ),
                      ],
                      [
                        html.div(
                          [
                            attribute.class(
                              "flex w-full items-center gap-2.5 bg-amber-500/10 rounded-sm p-4 transition-all duration-300",
                            ),
                          ],
                          [
                            html.div(
                              [
                                attribute("aria-hidden", "true"),
                                attribute.class(
                                  "rounded-full bg-amber-500/15 p-0.5 text-amber-500",
                                ),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5"),
                                    attribute("fill", "currentColor"),
                                    attribute("viewBox", "0 0 20 20"),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg",
                                    ),
                                  ],
                                  [
                                    svg.path([
                                      attribute("clip-rule", "evenodd"),
                                      attribute(
                                        "d",
                                        "M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z",
                                      ),
                                      attribute("fill-rule", "evenodd"),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                            html.div([attribute.class("flex flex-col gap-2")], [
                              html.h3(
                                [
                                  attribute("x-text", "notification.title"),
                                  attribute.class(
                                    "text-sm font-semibold text-amber-500",
                                  ),
                                  attribute("x-show", "notification.title"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                              html.p(
                                [
                                  attribute("x-text", "notification.message"),
                                  attribute.class("text-pretty text-sm"),
                                  attribute("x-show", "notification.message"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                            ]),
                            html.button(
                              [
                                attribute(
                                  "x-on:click",
                                  "(isVisible = false), removeNotification(notification.id)",
                                ),
                                attribute("aria-label", "dismiss notification"),
                                attribute.class("ml-auto"),
                                attribute.type_("button"),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5 shrink-0"),
                                    attribute("stroke-width", "2"),
                                    attribute("fill", "none"),
                                    attribute("stroke", "currentColor"),
                                    attribute("24", ""),
                                    attribute("0", ""),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg viewBox=",
                                    ),
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
                      ],
                    ),
                  ],
                ),
                html.template(
                  [attribute("x-if", "notification.variant === 'danger'")],
                  [
                    html.div(
                      [
                        attribute(
                          "x-transition:leave-start",
                          "translate-x-0 opacity-100",
                        ),
                        attribute(
                          "x-transition:leave-end",
                          "-translate-x-24 opacity-0 md:translate-x-24",
                        ),
                        attribute(
                          "x-transition:leave",
                          "transition duration-300 ease-in",
                        ),
                        attribute("x-transition:enter-start", "translate-y-8"),
                        attribute("x-transition:enter-end", "translate-y-0"),
                        attribute(
                          "x-transition:enter",
                          "transition duration-300 ease-out",
                        ),
                        attribute(
                          "x-init",
                          "$nextTick(() => { isVisible = true }), (timeout = setTimeout(() => { isVisible = false, removeNotification(notification.id)}, displayDuration))",
                        ),
                        attribute(
                          "x-on:resume-auto-dismiss.window",
                          " timeout = setTimeout(() => {(isVisible = false), removeNotification(notification.id) }, displayDuration)",
                        ),
                        attribute(
                          "x-on:pause-auto-dismiss.window",
                          "clearTimeout(timeout)",
                        ),
                        attribute.role("alert"),
                        attribute.class(
                          "pointer-events-auto relative rounded-sm border border-red-500 bg-white text-neutral-600 dark:bg-neutral-950 dark:text-neutral-300",
                        ),
                        attribute("x-show", "isVisible"),
                        attribute("x-cloak", ""),
                        attribute(
                          "x-data",
                          "{ isVisible: false, timeout: null }",
                        ),
                      ],
                      [
                        html.div(
                          [
                            attribute.class(
                              "flex w-full items-center gap-2.5 bg-red-500/10 rounded-sm p-4 transition-all duration-300",
                            ),
                          ],
                          [
                            html.div(
                              [
                                attribute("aria-hidden", "true"),
                                attribute.class(
                                  "rounded-full bg-red-500/15 p-0.5 text-red-500",
                                ),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5"),
                                    attribute("fill", "currentColor"),
                                    attribute("viewBox", "0 0 20 20"),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg",
                                    ),
                                  ],
                                  [
                                    svg.path([
                                      attribute("clip-rule", "evenodd"),
                                      attribute(
                                        "d",
                                        "M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z",
                                      ),
                                      attribute("fill-rule", "evenodd"),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                            html.div([attribute.class("flex flex-col gap-2")], [
                              html.h3(
                                [
                                  attribute("x-text", "notification.title"),
                                  attribute.class(
                                    "text-sm font-semibold text-red-500",
                                  ),
                                  attribute("x-show", "notification.title"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                              html.p(
                                [
                                  attribute("x-text", "notification.message"),
                                  attribute.class("text-pretty text-sm"),
                                  attribute("x-show", "notification.message"),
                                  attribute("x-cloak", ""),
                                ],
                                [],
                              ),
                            ]),
                            html.button(
                              [
                                attribute(
                                  "x-on:click",
                                  "(isVisible = false), removeNotification(notification.id)",
                                ),
                                attribute("aria-label", "dismiss notification"),
                                attribute.class("ml-auto"),
                                attribute.type_("button"),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5 shrink-0"),
                                    attribute("stroke-width", "2"),
                                    attribute("fill", "none"),
                                    attribute("stroke", "currentColor"),
                                    attribute("24", ""),
                                    attribute("0", ""),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg viewBox=",
                                    ),
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
                      ],
                    ),
                  ],
                ),
                html.template(
                  [attribute("x-if", "notification.variant === 'message'")],
                  [
                    html.div(
                      [
                        attribute(
                          "x-transition:leave-start",
                          "translate-x-0 opacity-100",
                        ),
                        attribute(
                          "x-transition:leave-end",
                          "-translate-x-24 opacity-0 md:translate-x-24",
                        ),
                        attribute(
                          "x-transition:leave",
                          "transition duration-300 ease-in",
                        ),
                        attribute("x-transition:enter-start", "translate-y-8"),
                        attribute("x-transition:enter-end", "translate-y-0"),
                        attribute(
                          "x-transition:enter",
                          "transition duration-300 ease-out",
                        ),
                        attribute(
                          "x-init",
                          "$nextTick(() => { isVisible = true }), (timeout = setTimeout(() => { isVisible = false, removeNotification(notification.id) }, displayDuration))",
                        ),
                        attribute(
                          "x-on:resume-auto-dismiss.window",
                          "timeout = setTimeout(() => { isVisible = false, removeNotification(notification.id) }, displayDuration)",
                        ),
                        attribute(
                          "x-on:pause-auto-dismiss.window",
                          "clearTimeout(timeout)",
                        ),
                        attribute.role("alert"),
                        attribute.class(
                          "pointer-events-auto relative rounded-sm border border-neutral-300 bg-white text-neutral-600 dark:border-neutral-700 dark:bg-neutral-950 dark:text-neutral-300",
                        ),
                        attribute("x-show", "isVisible"),
                        attribute("x-cloak", ""),
                        attribute(
                          "x-data",
                          "{ isVisible: false, timeout: null }",
                        ),
                      ],
                      [
                        html.div(
                          [
                            attribute.class(
                              "flex w-full rounded-sm items-center gap-2.5 bg-neutral-50 p-4 transition-all duration-300 dark:bg-neutral-900",
                            ),
                          ],
                          [
                            html.div(
                              [
                                attribute.class(
                                  "flex w-full items-center gap-2.5",
                                ),
                              ],
                              [
                                html.img([
                                  attribute(
                                    "x-bind:src",
                                    "notification.sender.avatar",
                                  ),
                                  attribute("aria-hidden", "true"),
                                  attribute.alt("avatar"),
                                  attribute.class("mr-2 size-12 rounded-full"),
                                  attribute(
                                    "x-show",
                                    "notification.sender.avatar",
                                  ),
                                  attribute("x-cloak", ""),
                                ]),
                                html.div(
                                  [
                                    attribute.class(
                                      "flex flex-col items-start gap-2",
                                    ),
                                  ],
                                  [
                                    html.h3(
                                      [
                                        attribute(
                                          "x-text",
                                          "notification.sender.name",
                                        ),
                                        attribute.class(
                                          "text-sm font-semibold text-neutral-900 dark:text-white",
                                        ),
                                        attribute(
                                          "x-show",
                                          "notification.sender.name",
                                        ),
                                        attribute("x-cloak", ""),
                                      ],
                                      [],
                                    ),
                                    html.p(
                                      [
                                        attribute(
                                          "x-text",
                                          "notification.message",
                                        ),
                                        attribute.class("text-pretty text-sm"),
                                        attribute(
                                          "x-show",
                                          "notification.message",
                                        ),
                                        attribute("x-cloak", ""),
                                      ],
                                      [],
                                    ),
                                    html.div(
                                      [
                                        attribute.class(
                                          "flex items-center gap-4",
                                        ),
                                      ],
                                      [
                                        html.button(
                                          [
                                            attribute.class(
                                              "whitespace-nowrap bg-transparent text-center text-sm font-bold tracking-wide text-black transition hover:opacity-75 active:opacity-100 dark:text-white",
                                            ),
                                            attribute.type_("button"),
                                          ],
                                          [html.text("Reply")],
                                        ),
                                        html.button(
                                          [
                                            attribute(
                                              "x-on:click",
                                              " (isVisible = false), setTimeout(() => { removeNotification(notification.id) }, 400)",
                                            ),
                                            attribute.class(
                                              "whitespace-nowrap bg-transparent text-center text-sm font-bold tracking-wide text-neutral-600 transition hover:opacity-75 active:opacity-100 dark:text-neutral-300",
                                            ),
                                            attribute.type_("button"),
                                          ],
                                          [html.text("Dismiss")],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            html.button(
                              [
                                attribute(
                                  "x-on:click",
                                  "(isVisible = false), removeNotification(notification.id)",
                                ),
                                attribute("aria-label", "dismiss notification"),
                                attribute.class("ml-auto"),
                                attribute.type_("button"),
                              ],
                              [
                                svg.svg(
                                  [
                                    attribute("aria-hidden", "true"),
                                    attribute.class("size-5 shrink-0"),
                                    attribute("stroke-width", "2"),
                                    attribute("fill", "none"),
                                    attribute("stroke", "currentColor"),
                                    attribute("24", ""),
                                    attribute("0", ""),
                                    attribute(
                                      "xmlns",
                                      "http://www.w3.org/2000/svg viewBox=",
                                    ),
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
                      ],
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ],
      ),
    ],
  )
}
