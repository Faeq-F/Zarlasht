import lustre/attribute.{attribute}
import lustre/element.{text}
import lustre/element/html

pub fn pubsub_test_page() -> String {
  html.div([attribute.class("join"), attribute.id("pageInputs")], [
    html.button(
      [
        attribute("ws-send", ""),
        attribute.id("test"),
        attribute("data-theme", "forest"),
        attribute.class(
          "btn join-item bg-secondary text-secondary-content hover:bg-accent",
        ),
      ],
      [text("test listening to chat channel")],
    ),
  ])
  |> element.to_string
}
