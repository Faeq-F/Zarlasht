import components/bottom_bar.{bottom_bar}
import lustre/attribute.{attribute, class, style}
import lustre/element.{type Element}
import lustre/element/html.{div, h1, text}

pub fn set_name() -> Element(t) {
  div(
    [
      class("!text-left !absolute"),
      style([#("width", "calc(100% - 2rem)"), #("height", "calc(100% - 2rem)")]),
    ],
    [
      div([class("!w-full")], [
        bottom_bar("set_name"),
        h1([class("!text-9xl font-header p-4")], [text("Zarlasht")]),
      ]),
    ],
  )
  // html.input([
  //   attribute.class(
  //     "input input-bordered bg-transparent join-item text-xl  w-full",
  //   ),
  //   attribute.placeholder(" Your Name"),
  // ]),
  // html.button(
  //   [
  //     attribute.class(
  //       "btn join-item bg-transparent hover:bg-transparent text-secondary-content hover:text-accent text-xl  text-shadow",
  //     ),
  //   ],
  //   [
  //     html.span([attribute.class("tick font-header ")], [
  //       html.text("L"),
  //     ]),
  //   ],


}
