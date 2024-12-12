//// SVG Lustre elements for different pages

import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/svg

/// Sun icon for switching to the light theme on the site
///
pub fn sun(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 24 24"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(classes),
    ],
    [
      svg.path([
        attribute(
          "d",
          "M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z",
        ),
      ]),
    ],
  )
}

/// Moon icon for switching to the dark theme on the site
///
pub fn moon(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 24 24"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(classes),
    ],
    [
      svg.path([
        attribute(
          "d",
          "M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z",
        ),
      ]),
    ],
  )
}

/// GitHub icon for opening a new tab with this project's repository
///
pub fn github(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 24 24"),
      attribute("height", "24"),
      attribute("width", "24"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(classes),
    ],
    [
      svg.path([
        attribute(
          "d",
          "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z",
        ),
      ]),
    ],
  )
}

/// A tick icon for confirmations, etc.
///
pub fn tick(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute.class(classes),
      attribute("preserveAspectRatio", "xMidYMid meet"),
      attribute("viewBox", "0 0 5120.000000 5120.000000"),
      attribute("height", "5120.000000pt"),
      attribute("width", "5120.000000pt"),
      attribute("version", "1.0"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
    ],
    [
      svg.g(
        [
          attribute("stroke", "none"),
          attribute("fill", "#000000"),
          attribute(
            "transform",
            "translate(0.000000,5120.000000) scale(0.100000,-0.100000)",
          ),
        ],
        [
          svg.path([
            attribute(
              "d",
              "M40510 40544 c-466 -30 -793 -91 -1170 -219 -491 -167 -908 -404 -1335 -756 -56 -46 -4208 -4189 -9537 -9517 l-9437 -9436 -2850 2851 c-1675 1676 -2901 2894 -2973 2955 -648 550 -1405 876 -2253 970 -76 8 -239 13 -445 13 -363 -1 -506 -15 -822 -79 -1419 -291 -2590 -1321 -3062 -2694 -98 -287 -164 -582 -202 -907 -22 -185 -25 -661 -6 -835 73 -650 263 -1220 583 -1748 142 -235 311 -456 511 -672 219 -236 8753 -8757 8853 -8839 284 -234 553 -411 850 -556 801 -392 1694 -512 2583 -350 697 128 1390 462 1927 928 61 52 5049 5036 11086 11074 9300 9301 10993 10999 11083 11113 775 975 1071 2223 815 3435 -162 768 -530 1457 -1079 2019 -361 368 -709 621 -1155 837 -446 216 -896 344 -1385 393 -147 15 -479 27 -580 20z",
            ),
          ]),
        ],
      ),
    ],
  )
}

/// A replay icon for replaying the game
///
pub fn replay(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 32 32"),
      attribute("height", "100"),
      attribute("width", "100"),
      attribute("y", "0px"),
      attribute("x", "0px"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(classes),
    ],
    [
      svg.path([
        attribute(
          "d",
          "M 16 4 L 16 6 C 21.535156 6 26 10.464844 26 16 C 26 21.535156 21.535156 26 16 26 C 10.464844 26 6 21.535156 6 16 C 6 12.734375 7.585938 9.851563 10 8.03125 L 10 13 L 12 13 L 12 5 L 4 5 L 4 7 L 8.09375 7 C 5.59375 9.199219 4 12.417969 4 16 C 4 22.617188 9.382813 28 16 28 C 22.617188 28 28 22.617188 28 16 C 28 9.382813 22.617188 4 16 4 Z",
        ),
      ]),
    ],
  )
}

/// A nought for when the O player makes a mark
///
pub fn nought(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute("preserveAspectRatio", "xMidYMid meet"),
      attribute("viewBox", "0 0 100.000000 100.000000"),
      attribute("height", "100.000000pt"),
      attribute("width", "100.000000pt"),
      attribute("version", "1.0"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(classes),
    ],
    [
      svg.g(
        [
          attribute("stroke", "none"),
          attribute(
            "transform",
            "translate(0.000000,100.000000) scale(0.100000,-0.100000)",
          ),
        ],
        [
          svg.path([
            attribute(
              "d",
              "M400 949 c-115 -23 -239 -125 -279 -233 -49 -131 -52 -288 -7 -412 44 -119 112 -192 224 -235 46 -18 78 -22 162 -23 120 0 185 19 262 78 187 143 211 521 45 712 -85 97 -251 144 -407 113z m173 -160 c53 -14 110 -69 138 -132 20 -44 23 -68 23 -157 0 -89 -3 -113 -23 -157 -85 -192 -337 -192 -422 0 -20 44 -23 68 -23 157 0 126 22 190 88 246 60 52 135 67 219 43z",
            ),
          ]),
        ],
      ),
    ],
  )
}

/// A cross for when the X player makes a mark
///
pub fn cross(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 72 72"),
      attribute("height", "100"),
      attribute("width", "100"),
      attribute("y", "0px"),
      attribute("x", "0px"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class(classes),
    ],
    [
      svg.path([
        attribute(
          "d",
          "M 19 15 C 17.977 15 16.951875 15.390875 16.171875 16.171875 C 14.609875 17.733875 14.609875 20.266125 16.171875 21.828125 L 30.34375 36 L 16.171875 50.171875 C 14.609875 51.733875 14.609875 54.266125 16.171875 55.828125 C 16.951875 56.608125 17.977 57 19 57 C 20.023 57 21.048125 56.609125 21.828125 55.828125 L 36 41.65625 L 50.171875 55.828125 C 51.731875 57.390125 54.267125 57.390125 55.828125 55.828125 C 57.391125 54.265125 57.391125 51.734875 55.828125 50.171875 L 41.65625 36 L 55.828125 21.828125 C 57.390125 20.266125 57.390125 17.733875 55.828125 16.171875 C 54.268125 14.610875 51.731875 14.609875 50.171875 16.171875 L 36 30.34375 L 21.828125 16.171875 C 21.048125 15.391875 20.023 15 19 15 z",
        ),
      ]),
    ],
  )
}

/// A filler for a box when there is no mark in it
///
pub fn empty(classes: String) -> Element(svg) {
  svg.svg(
    [
      attribute.class(classes),
      attribute("x", "0px"),
      attribute("y", "0px"),
      attribute("width", "100"),
      attribute("height", "100"),
      attribute("viewBox", "0 0 72 72"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
    ],
    [],
  )
}
