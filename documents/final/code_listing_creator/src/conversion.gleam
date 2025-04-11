//// The page & the conversion logic

import contour
import gleam/list.{fold, map}
import gleam/string.{split}
import gleam/string_tree
import lustre/attribute.{attribute, href, id, name, rel, src, style}
import lustre/element/html.{
  body, button, div, form, head, html, li, link, p, script, text, textarea, ul,
}

/// The home page
///
pub fn home() {
  html([], [
    head([], [
      link([rel("stylesheet"), href("/static/style.css")]),
      // HTMX for dynamic changes
      script(
        [
          attribute("crossorigin", "anonymous"),
          attribute(
            "integrity",
            "sha384-HGfztofotfshcF7+8n44JQL2oJmowVChPTg48S+jvZoztPfvwD79OC/LTtG6dMp+",
          ),
          src("https://unpkg.com/htmx.org@2.0.4"),
        ],
        "",
      ),
    ]),
    body([], [
      div([id("bodyDiv")], [
        //tips
        p([], [text("Use gecko-based browser for text selectability")]),
        text("Printing options;"),
        ul([], [
          li([], [text("Background Graphics")]),
          li([], [text("Fit to page width")]),
        ]),
        //input
        form([], [
          textarea(
            [name("source"), style([#("width", " 90vw"), #("height", "80vh")])],
            "",
          ),
          button(
            [
              attribute("hx-target", "#bodyDiv"),
              attribute("hx-post", "/source"),
            ],
            [text("Convert")],
          ),
        ]),
      ]),
      //trigger print to pdf after code is swapped into the DOM
      script(
        [],
        "document.body.addEventListener('htmx:afterSwap', function(evt) {
          "<> js()<>"
          window.print()
        });",
      ),
    ]),
  ])
}

/// Convert to HTML with CSS classes for colours
///
pub fn convert(source: String) {
  let html =
    "<body><pre>"
    <> contour.to_html(source)
    |> split("\n")
    |> map(fn(line) { "<code>" <> line <> "</code>" })
    |> fold("", fn(old_lines, next_line) { old_lines <> "\n" <> next_line })
    <> "</pre>"
    <> "</body>"
  string_tree.from_string(html)
}

/// Further highlighting using the prefixedColon class
///
fn js() {
  "

  const regex = /(?:[^^.+\\b](\\w+): )/gm;
  Array.from(document.getElementsByTagName(\"code\")).forEach((x)=>{
  let str = x.innerHTML
  let m;
  while ((m = regex.exec(str)) !== null) {
        if (m.index === regex.lastIndex) {
            regex.lastIndex++;
        }

        // The result can be accessed through the `m`-variable.
        m.forEach((match, groupIndex) => {
            if (groupIndex == 1)
                document.body.innerHTML = document.body.innerHTML.replaceAll(`${match}:`, `<span class=\"prefixedColon\">${match}:</span>`)
        });
    }
  })
  "
}
