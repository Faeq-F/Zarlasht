//// The home page of the site

import gleam/http
import gleam/javascript/promise.{type Promise}
import glen.{type Request, type Response}
import glen/status
import lustre/attribute.{attribute}
import lustre/element.{text}
import lustre/element/html
import pages/layout

/// The home page of the site
///
/// A page with two buttons; one for creating a chat and another for joining a chat
///
/// The function takes in the request to the site, creates the page and wraps
/// it in `pages/layout`, and converts it `to_document_string`. It then creates a
/// `status.ok` response and returns a resolved promise with it
///
pub fn home_page(req: Request) -> Promise(Response) {
  use <- glen.require_method(req, http.Get)
  [
    html.div([attribute.class("hero bg-base-100 min-h-full")], [
      html.div(
        [
          attribute.class(
            "hero-content text-center absolute top-1/2 -translate-y-1/2",
          ),
        ],
        [
          html.div([attribute.class("max-w-md")], [
            html.h1([attribute.class("text-5xl font-bold mb-3")], [
              element.text("Online Chat"),
            ]),
            html.div([attribute.class("join"), attribute.id("pageInputs")], [
              html.button(
                [
                  attribute("ws-send", ""),
                  attribute.id("create"),
                  attribute("data-theme", "forest"),
                  attribute.class(
                    "btn join-item bg-secondary text-secondary-content hover:bg-accent",
                  ),
                ],
                [text("Create a chat")],
              ),
              html.button(
                [
                  attribute("ws-send", ""),
                  attribute.id("join"),
                  attribute("data-theme", "forest"),
                  attribute.class(
                    "btn join-item bg-neutral hover:bg-accent hover:text-secondary-content",
                  ),
                ],
                [text("Join a chat")],
              ),
            ]),
          ]),
        ],
      ),
    ]),
  ]
  |> layout.layout()
  |> element.to_document_string()
  |> glen.html(status.ok)
  |> promise.resolve
}
