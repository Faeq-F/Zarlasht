//// The page & conversion logic

import birl
import contour
import file_streams/file_stream
import gleam/string_tree
import lustre/attribute.{attribute, href, id, name, rel, src}
import lustre/element/html.{
  body, button, div, form, head, html, link, script, text, textarea,
}

// ensure backgraound graphics is enabled

/// The home page
///
pub fn home() {
  html([], [
    head([], [
      link([rel("stylesheet"), href("/static/style.css")]),
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
        form([], [
          textarea([name("source")], ""),
          button(
            [
              attribute("hx-target", "#bodyDiv"),
              attribute("hx-post", "/source"),
            ],
            [text("Convert")],
          ),
        ]),
      ]),
    ]),
  ])
}

pub fn convert(source: String) {
  // Convert to HTML with CSS classes for colours
  let html =
    "<body><pre><code>"
    <> contour.to_html(source)
    <> "</code></pre>"
    <> js()
    <> "</body>"
  //use chrobot to convert to pdf & save that to disk
  //save to disk
  // let assert Ok(stream) =
  //   file_stream.open_write(birl.now() |> birl.to_iso8601() <> ".pdf")
  // let assert Ok(Nil) = file_stream.write_bytes(stream, <<"Hello!\n":utf8>>)
  // let assert Ok(Nil) = file_stream.close(stream)
  //return val
  string_tree.from_string(html)
}

fn js() {
  "
  <script>
  const regex = /(?:[^^.+\\b](\\w+): )/gm;

  const str = document.getElementsByTagName(\"code\")[0].innerHTML

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

  let code = document.getElementsByTagName(\"code\")[0].innerHTML
  code = code.replaceAll(\"(\",\"<span class=\\\"outer\\\">(</span>\")
  code = code.replaceAll(\")\",\"<span class=\\\"outer\\\">)</span>\")
  code = code.replaceAll(\"[\",\"<span class=\\\"outer\\\">[</span>\")
  code = code.replaceAll(\"]\",\"<span class=\\\"outer\\\">]</span>\")
  code = code.replaceAll(\"{\",\"<span class=\\\"outer\\\">{</span>\")
  code = code.replaceAll(\"}\",\"<span class=\\\"outer\\\">}</span>\")
  code = code.replaceAll(\",\",\"<span class=\\\"outer\\\">,</span>\")
  document.getElementsByTagName(\"code\")[0].innerHTML = code

  window.print()
  </script>
  "
}
