//// The page seen when the user has entered the game

import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

// Todo
//seperate page into functions
// add hint for spin on the ball

/// The game page - where users play the game
///
/// Modified from [GeeksForGeeks](https://www.geeksforgeeks.org/pong-game-in-javascript/)<br>
/// (This project was made to show that the code stack is versatile)
///
/// Returns stringified HTML to send to the websocket
///
pub fn game_page(player1name: String, player2name: String) -> String {
  html.div([attribute.class("bg-base-100 min-h-full"), attribute.id("page")], [
    html.div(
      [
        attribute.id("Enter"),
        attribute("ws-send", ""),
        attribute("hx-trigger", "pageLoaded, keyup[key=='Enter'] from:body"),
        attribute("hx-include", "[name='extraInfo']"),
      ],
      [],
    ),
    html.div(
      [
        attribute.id("Wkey"),
        attribute("ws-send", ""),
        attribute("hx-trigger", "keyup[key=='w'] from:body"),
        attribute("hx-include", "[name='extraInfo']"),
      ],
      [],
    ),
    html.div(
      [
        attribute.id("Skey"),
        attribute("ws-send", ""),
        attribute("hx-trigger", "keyup[key=='s'] from:body"),
        attribute("hx-include", "[name='extraInfo']"),
      ],
      [],
    ),
    html.div(
      [
        attribute.id("UpArrowKey"),
        attribute("ws-send", ""),
        attribute("hx-trigger", "keyup[key=='ArrowUp'] from:body"),
        attribute("hx-include", "[name='extraInfo']"),
      ],
      [],
    ),
    html.div(
      [
        attribute.id("DownArrowKey"),
        attribute("ws-send", ""),
        attribute("hx-trigger", "keyup[key=='ArrowDown'] from:body"),
        attribute("hx-include", "[name='extraInfo']"),
      ],
      [],
    ),
    html.div([attribute.class("hidden")], [
      html.input([attribute.type_("text"), attribute.name("extraInfo")]),
    ]),
    html.div(
      [
        attribute.class(
          "divider lg:divider-horizontal absolute min-w-full left-0 top-1/2 -translate-y-1/2 h-96 m-0",
        ),
      ],
      [],
    ),
    html.div(
      [attribute.class(" border border-current"), attribute.id("board")],
      [
        html.div([attribute.class("bg-base-content"), attribute.id("ball")], []),
        html.div(
          [
            attribute.class(" paddle bg-secondary border border-neutral"),
            attribute.id("paddle_1"),
          ],
          [],
        ),
        html.div(
          [
            attribute.class("  paddle bg-accent border border-neutral"),
            attribute.id("paddle_2"),
          ],
          [],
        ),
        html.div(
          [
            attribute.class(
              "fixed left-1/4 mt-[30px]  grid grid-cols-3 grid-rows-2 gap-0",
            ),
          ],
          [
            html.div([attribute.class("col-span-2")], [
              html.p([], [html.text(player1name)]),
            ]),
            html.div([attribute.class("col-span-2 col-start-1 row-start-2")], [
              html.kbd([attribute.class("kbd mr-1")], [html.text("W")]),
              html.kbd([attribute.class("kbd")], [html.text("S")]),
            ]),
            html.div(
              [
                attribute.class(
                  "row-span-2 col-start-3 row-start-1 ml-4 text-6xl pl-4",
                ),
              ],
              [html.p([attribute.id("player_1_score")], [html.text("0")])],
            ),
          ],
        ),
        html.div(
          [
            attribute.class(
              "fixed right-1/4 mt-[30px]   grid grid-cols-3 grid-rows-2 gap-0",
            ),
          ],
          [
            html.div([attribute.class("col-span-2")], [
              html.p([], [html.text(player2name)]),
            ]),
            html.div([attribute.class("col-span-2 col-start-1 row-start-2")], [
              html.kbd([attribute.class("kbd mr-1")], [html.text("↑")]),
              html.kbd([attribute.class("kbd")], [html.text("↓")]),
            ]),
            html.div(
              [
                attribute.class(
                  "row-span-2 col-start-3 row-start-1 ml-4 text-6xl pl-4",
                ),
              ],
              [html.p([attribute.id("player_2_score")], [html.text("0")])],
            ),
          ],
        ),
        instruction(True),
      ],
    ),
    inject_js(""),
    html.script(
      [],
      "
    let paddle_1 = document.querySelector('#paddle_1');
    let paddle_2 = document.querySelector('#paddle_2');

    let board = document.querySelector('#board');
    let initial_ball = document.querySelector('#ball');
    let ball = document.querySelector('#ball');

    let score_1 = document.querySelector('#player_1_score');
    let score_2 = document.querySelector('#player_2_score');

    let paddle_1_coord = paddle_1.getBoundingClientRect();
    let paddle_2_coord = paddle_2.getBoundingClientRect();
    let initial_ball_coord = ball.getBoundingClientRect();
    let ball_coord = initial_ball_coord;
    let board_coord = board.getBoundingClientRect();
    let paddle_common =
      document.querySelector('.paddle').getBoundingClientRect();

    let dx = Math.floor(Math.random() * 4) + 3;
    let dy = Math.floor(Math.random() * 4) + 3;
    let dxd = Math.floor(Math.random() * 2);
    let dyd = Math.floor(Math.random() * 2);

    function extraInfoFill(simulateKeyHit){
      document.getElementsByName('extraInfo')[0].value = JSON.stringify(
        {
board_coord: board_coord,
window_innerHeight: window.innerHeight,
paddle_1_coord: paddle_1_coord,
paddle_2_coord: paddle_2_coord,
paddle_common: paddle_common,
player_1_score: score_1.innerHTML,
player_2_score: score_2.innerHTML,
        }
      );
      if (simulateKeyHit){
        htmx.trigger(\"#Enter\", \"pageLoaded\")
      }
    }

    document.addEventListener('keydown', (e) => {
      if (e.key == 'Enter' || e.key == 'w' || e.key == 's' || e.key == 'ArrowUp' || e.key == 'ArrowDown'){
        extraInfoFill(false);
      }
    });



    function moveBall(dx, dy, dxd, dyd) {
      if (ball_coord.top <= board_coord.top) {
        dyd = 1;
      }
      if (ball_coord.bottom >= board_coord.bottom) {
        dyd = 0;
      }

      if (
        ball_coord.left <= paddle_1_coord.right &&
        ball_coord.top >= paddle_1_coord.top &&
        ball_coord.bottom <= paddle_1_coord.bottom
      ) {
        dxd = 1;
        dx = Math.floor(Math.random() * 4) + 3;
        dy = Math.floor(Math.random() * 4) + 3;
      }

      if (
        ball_coord.right >= paddle_2_coord.left &&
        ball_coord.top >= paddle_2_coord.top &&
        ball_coord.bottom <= paddle_2_coord.bottom
      ) {
        dxd = 0;
        dx = Math.floor(Math.random() * 4) + 3;
        dy = Math.floor(Math.random() * 4) + 3;
      }

      if (
        ball_coord.left <= board_coord.left ||
        ball_coord.right >= board_coord.right
      ) {
        if (ball_coord.left <= board_coord.left) {
          score_2.innerHTML = +score_2.innerHTML + 1;
        } else {
          score_1.innerHTML = +score_1.innerHTML + 1;
        }
        ball_coord = initial_ball_coord;
        ball.style = initial_ball.style;
        extraInfoFill(true);
        return;
      }

      ball.style.top = ball_coord.top + dy * (dyd == 0 ? -1 : 1) + 'px';
      ball.style.left = ball_coord.left + dx * (dxd == 0 ? -1 : 1) + 'px';
      ball_coord = ball.getBoundingClientRect();
      requestAnimationFrame(() => {
        moveBall(dx, dy, dxd, dyd);
      });
    }
  ",
    ),
  ])
  |> element.to_string
}

/// The instruction for the user to start the game
///
pub fn instruction(show: Bool) {
  case show {
    True -> {
      html.h1(
        [
          attribute.class(
            " absolute left-0 -translate-y-1/2 min-w-full text-center top-10",
          ),
          attribute.id("instruction"),
        ],
        [html.text("Press Enter to Start")],
      )
    }
    _ -> {
      html.h1(
        [
          attribute.class(
            " absolute left-0 -translate-y-1/2 min-w-full text-center top-10",
          ),
          attribute.id("instruction"),
        ],
        [html.text("")],
      )
    }
  }
}

/// The script element used to update the client DOM, based off server events
///
/// updates to the DOM via this function, occurs by running JS that manipulates the DOM
///
pub fn inject_js(script: String) {
  html.script([attribute.id("inject_js")], script)
}
