//// The page & conversion logic

import birl
import contour
import file_streams/file_stream
import gleam/list.{fold, map}
import gleam/string.{split}
import gleam/string_tree
import lustre/attribute.{attribute, href, id, name, rel, src}
import lustre/element/html.{
  body, button, div, form, head, html, link, script, text, textarea,
}

// ensure backgraound graphics is enabled & fit to printable area

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
    // script(
    //   [
    //     src(
    //       "https://cdnjs.cloudflare.com/ajax/libs/jspdf/3.0.1/jspdf.umd.min.js",
    //     ),
    //   ],
    //   "",
    // ),
    // script(
    //   [
    //     src(
    //       "https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js",
    //     ),
    //   ],
    //   "",
    // ),
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
      trigger_pdf(),
    ]),
  ])
}

pub fn convert(source: String) {
  // Convert to HTML with CSS classes for colours
  let html =
    "<body><pre>"
    <> contour.to_html(source)
    |> split("\n")
    |> map(fn(line) { "<code>" <> line <> "</code>" })
    |> fold("", fn(old_lines, next_line) { old_lines <> "\n" <> next_line })
    <> "</pre>"
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
  </script>
  "
}

fn trigger_pdf() {
  script(
    [],
    "
  // const font = new FontFace(\"CaskaydiaCove-Regular\", \"url(https://github.com/eliheuer/caskaydia-cove/raw/refs/heads/master/fonts/otf/CaskaydiaCove-Regular.otf)\");
  // font.load()

  // const { jsPDF } = window.jspdf;
  // const { html2canvas } = window.html2canvas;

  document.body.addEventListener('htmx:afterSwap', function(evt) {
    // var doc = new jsPDF();
    // doc.html(evt.detail.elt, {
    //   callback: (pdf) => {pdf.save('code.pdf')},
    //   x: 0,
    //   y: 0,
    //   width: 200,
    //   windowWidth: 800,
    //   fontFaces: [font]
    // });
    window.print()
  });
  ",
  )
}
