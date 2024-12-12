import app/actors/actor_types
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html.{text}
import lustre/element/svg

// Modified from https://www.geeksforgeeks.org/pong-game-in-javascript/
// (This project was made to show that the code stack is versatile)
pub fn game_page() -> String {
  html.div([attribute.class("bg-base-100 min-h-full"), attribute.id("page")], [
    html.div(
      [
        attribute.class(
          "divider lg:divider-horizontal absolute min-w-full left-0 top-1/2 -translate-y-1/2 h-96",
        ),
      ],
      [],
    ),
    html.div(
      [
        attribute.class(
          "hero-content text-center absolute top-1/2 -translate-y-1/2 min-w-full h-screen pt-16 pb-12 left-0",
        ),
      ],
      [
        html.div([attribute.class("grid grid-cols-2 gap-10 w-full h-full")], [
          html.div([attribute.class("card text-center h-full")], [
            html.div(
              [
                attribute.class("w-4/6 h-1/7 rounded-3xl p-4 pl-36 text-left"),
                attribute.id("player1"),
              ],
              [],
            ),
            html.div(
              [
                attribute.class(
                  "m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full",
                ),
                attribute.id("game"),
              ],
              [],
            ),
          ]),
          html.div([attribute.class("card text-center h-full")], [
            html.div(
              [
                attribute.class(
                  "m-auto w-4/6 h-full mx-auto my-0 p-4 grid grid-cols-3 gap-4 h-full",
                ),
                attribute.id("game"),
              ],
              [],
            ),
            html.div(
              [
                attribute.class(
                  "w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-0 pr-36 text-right",
                ),
                attribute.id("player2"),
              ],
              [],
            ),
          ]),
        ]),
      ],
    ),
    //hx-trigger="click, keyup[altKey&&shiftKey&&key=='D'] from:body"
    html.div([attribute.class("board")], [
      html.div([attribute.class("ball")], [
        html.div([attribute.class("ball_effect")], []),
      ]),
      html.div([attribute.class("paddle_1 paddle")], []),
      html.div([attribute.class("paddle_2  paddle")], []),
      html.h1([attribute.class("player_1_score")], [html.text("0")]),
      html.h1([attribute.class("player_2_score")], [html.text("0")]),
      html.h1(
        [
          attribute.class(
            "message absolute left-0 -translate-y-1/2 min-w-full text-center",
          ),
        ],
        [html.text("Press Enter to Start")],
      ),
    ]),
    html.script(
      [],
      "
    let gameState = 'start';
    let paddle_1 = document.querySelector('.paddle_1');
    let paddle_2 = document.querySelector('.paddle_2');
    let board = document.querySelector('.board');
    let initial_ball = document.querySelector('.ball');
    let ball = document.querySelector('.ball');
    let score_1 = document.querySelector('.player_1_score');
    let score_2 = document.querySelector('.player_2_score');
    let message = document.querySelector('.message');
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

    document.addEventListener('keydown', (e) => {
      if (e.key == 'Enter') {
        gameState = gameState == 'start' ? 'play' : 'start';
        if (gameState == 'play') {
          message.innerHTML = '';
          requestAnimationFrame(() => {
            dx = Math.floor(Math.random() * 4) + 3;
            dy = Math.floor(Math.random() * 4) + 3;
            dxd = Math.floor(Math.random() * 2);
            dyd = Math.floor(Math.random() * 2);
            moveBall(dx, dy, dxd, dyd);
          });
        }
      }
      if (gameState == 'play') {
        if (e.key == 'w') {
          paddle_1.style.top =
            Math.max(
              board_coord.top,
              paddle_1_coord.top - window.innerHeight * 0.06
            ) + 'px';
          paddle_1_coord = paddle_1.getBoundingClientRect();
        }
        if (e.key == 's') {
          paddle_1.style.top =
            Math.min(
              board_coord.bottom - paddle_common.height,
              paddle_1_coord.top + window.innerHeight * 0.06
            ) + 'px';
          paddle_1_coord = paddle_1.getBoundingClientRect();
        }

        if (e.key == 'ArrowUp') {
          paddle_2.style.top =
            Math.max(
              board_coord.top,
              paddle_2_coord.top - window.innerHeight * 0.1
            ) + 'px';
          paddle_2_coord = paddle_2.getBoundingClientRect();
        }
        if (e.key == 'ArrowDown') {
          paddle_2.style.top =
            Math.min(
              board_coord.bottom - paddle_common.height,
              paddle_2_coord.top + window.innerHeight * 0.1
            ) + 'px';
          paddle_2_coord = paddle_2.getBoundingClientRect();
        }
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
        gameState = 'start';

        ball_coord = initial_ball_coord;
        ball.style = initial_ball.style;
        message.innerHTML = 'Press Enter to Start';
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

pub fn player(player: actor_types.Player, name: String) -> String {
  case player {
    actor_types.One -> {
      html.div(
        [
          attribute.class("w-4/6 h-1/7 rounded-3xl p-4 pl-36 text-left"),
          attribute.id("player1"),
        ],
        [html.p([attribute.class("inline text-lg")], [text(name)])],
      )
      |> element.to_string
    }
    _ -> {
      html.div(
        [
          attribute.class(
            "w-4/6 h-1/7 rounded-3xl p-4 mr-0 ml-auto pr-36 text-right",
          ),
          attribute.id("player2"),
        ],
        [html.p([attribute.class("inline text-lg")], [text(name)])],
      )
      |> element.to_string
    }
  }
}

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
