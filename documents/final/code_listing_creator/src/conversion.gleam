import contour
import gleam/io
import gleam/string_tree
import lustre/attribute.{attribute, name}
import lustre/element/html.{button, div, form, text, textarea}

pub fn home() {
  html.html([], [
    html.head([], [
      html.script(
        [
          attribute("crossorigin", "anonymous"),
          attribute(
            "integrity",
            "sha384-HGfztofotfshcF7+8n44JQL2oJmowVChPTg48S+jvZoztPfvwD79OC/LTtG6dMp+",
          ),
          attribute.src("https://unpkg.com/htmx.org@2.0.4"),
        ],
        "",
      ),
    ]),
    html.body([], [
      div([], [
        form([], [
          textarea([name("source")], ""),
          button(
            [attribute("hx-swap", "outerHTML"), attribute("hx-post", "/source")],
            [text("Convert")],
          ),
        ]),
      ]),
    ]),
  ])
}

pub fn convert(source: String) {
  // Convert to HTML with CSS classes for colours
  let html = contour.to_html(source)
  string_tree.from_string("<pre><code>" <> html <> "</code></pre>")
}
