import app/actors/actor_types.{
  type LeaderboardInformation, LeaderboardInformation,
}
import app/pages/leaderboard.{leaderboard}
import glacier/should

pub fn empty_leaderboard_test() {
  should.equal(
    leaderboard([]),
    "<div id=\"overlay\" class=\"w-screen h-screen absolute bg-base-100 z-[999] left-0 top-0\"><label id=\"Xleaderboard\" ws-send class=\"right-0 m-4 fixed z-10 bottom-0 cursor-pointer\"><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 6 6 18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m6 6 12 12\"></path></svg></label><div class=\"overflow-x-auto absolute w-screen rounded-lg text-3xl text-center top-6\">Leaderboard</div><div class=\"overflow-x-auto h-[90vh] absolute w-[90vw] left-1/2 -translate-x-1/2 border border-current rounded-2xl bottom-3\"><table class=\"table table-pin-rows table-pin-cols\"><thead><tr class=\"border-current\"><th></th><th>Player 1</th><th>Player 2</th><th>Score</th><th>Difference</th></tr></thead><tbody></tbody></table></div></div>",
  )
}

pub fn empty_leaderboard_fields_1_test() {
  should.equal(
    leaderboard([
      LeaderboardInformation(
        player1name: "",
        player2name: "",
        player1score: 0,
        player2score: 0,
      ),
    ]),
    "<div id=\"overlay\" class=\"w-screen h-screen absolute bg-base-100 z-[999] left-0 top-0\"><label id=\"Xleaderboard\" ws-send class=\"right-0 m-4 fixed z-10 bottom-0 cursor-pointer\"><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 6 6 18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m6 6 12 12\"></path></svg></label><div class=\"overflow-x-auto absolute w-screen rounded-lg text-3xl text-center top-6\">Leaderboard</div><div class=\"overflow-x-auto h-[90vh] absolute w-[90vw] left-1/2 -translate-x-1/2 border border-current rounded-2xl bottom-3\"><table class=\"table table-pin-rows table-pin-cols\"><thead><tr class=\"border-current\"><th></th><th>Player 1</th><th>Player 2</th><th>Score</th><th>Difference</th></tr></thead><tbody><tr class=\"border-current\"><th><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 9H4.5a2.5 2.5 0 0 1 0-5H6\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 9h1.5a2.5 2.5 0 0 0 0-5H18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M4 22h16\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 2H6v7a6 6 0 0 0 12 0V2Z\"></path></svg>1st</th><td><div class=\"badge badge-accent ml-2\">Winner</div></td><td></td><td>0 - 0</td><td>0</td></tr></tbody></table></div></div>",
  )
}

pub fn empty_leaderboard_fields_2_test() {
  should.equal(
    leaderboard([
      LeaderboardInformation(
        player1name: "",
        player2name: "",
        player1score: 0,
        player2score: 0,
      ),
      LeaderboardInformation(
        player1name: "",
        player2name: "",
        player1score: 0,
        player2score: 0,
      ),
    ]),
    "<div id=\"overlay\" class=\"w-screen h-screen absolute bg-base-100 z-[999] left-0 top-0\"><label id=\"Xleaderboard\" ws-send class=\"right-0 m-4 fixed z-10 bottom-0 cursor-pointer\"><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 6 6 18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m6 6 12 12\"></path></svg></label><div class=\"overflow-x-auto absolute w-screen rounded-lg text-3xl text-center top-6\">Leaderboard</div><div class=\"overflow-x-auto h-[90vh] absolute w-[90vw] left-1/2 -translate-x-1/2 border border-current rounded-2xl bottom-3\"><table class=\"table table-pin-rows table-pin-cols\"><thead><tr class=\"border-current\"><th></th><th>Player 1</th><th>Player 2</th><th>Score</th><th>Difference</th></tr></thead><tbody><tr class=\"border-current\"><th><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 9H4.5a2.5 2.5 0 0 1 0-5H6\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 9h1.5a2.5 2.5 0 0 0 0-5H18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M4 22h16\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 2H6v7a6 6 0 0 0 12 0V2Z\"></path></svg>1st</th><td><div class=\"badge badge-accent ml-2\">Winner</div></td><td></td><td>0 - 0</td><td>0</td></tr><tr class=\"border-current\"><th><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M11 12 5.12 2.2\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m13 12 5.88-9.8\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M8 7h8\"></path><circle xmlns=\"http://www.w3.org/2000/svg\" r=\"5\" cy=\"17\" cx=\"12\"></circle><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M12 18v-2h-.5\"></path></svg>2nd</th><td><div class=\"badge badge-accent ml-2\">Winner</div></td><td></td><td>0 - 0</td><td>0</td></tr></tbody></table></div></div>",
  )
}

pub fn filled_leaderboard_1_test() {
  should.equal(
    leaderboard([
      LeaderboardInformation(
        player1name: "Faeq",
        player2name: "John",
        player1score: 3,
        player2score: 9,
      ),
    ]),
    "<div id=\"overlay\" class=\"w-screen h-screen absolute bg-base-100 z-[999] left-0 top-0\"><label id=\"Xleaderboard\" ws-send class=\"right-0 m-4 fixed z-10 bottom-0 cursor-pointer\"><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 6 6 18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m6 6 12 12\"></path></svg></label><div class=\"overflow-x-auto absolute w-screen rounded-lg text-3xl text-center top-6\">Leaderboard</div><div class=\"overflow-x-auto h-[90vh] absolute w-[90vw] left-1/2 -translate-x-1/2 border border-current rounded-2xl bottom-3\"><table class=\"table table-pin-rows table-pin-cols\"><thead><tr class=\"border-current\"><th></th><th>Player 1</th><th>Player 2</th><th>Score</th><th>Difference</th></tr></thead><tbody><tr class=\"border-current\"><th><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 9H4.5a2.5 2.5 0 0 1 0-5H6\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 9h1.5a2.5 2.5 0 0 0 0-5H18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M4 22h16\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 2H6v7a6 6 0 0 0 12 0V2Z\"></path></svg>1st</th><td>Faeq</td><td>John<div class=\"badge badge-accent ml-2\">Winner</div></td><td>3 - 9</td><td>6</td></tr></tbody></table></div></div>",
  )
}

pub fn filled_leaderboard_2_test() {
  should.equal(
    leaderboard([
      LeaderboardInformation(
        player1name: "Faeq",
        player2name: "John",
        player1score: 3,
        player2score: 9,
      ),
      LeaderboardInformation(
        player1name: "Faeq",
        player2name: "Mubz",
        player1score: 2,
        player2score: 20,
      ),
    ]),
    "<div id=\"overlay\" class=\"w-screen h-screen absolute bg-base-100 z-[999] left-0 top-0\"><label id=\"Xleaderboard\" ws-send class=\"right-0 m-4 fixed z-10 bottom-0 cursor-pointer\"><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 6 6 18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m6 6 12 12\"></path></svg></label><div class=\"overflow-x-auto absolute w-screen rounded-lg text-3xl text-center top-6\">Leaderboard</div><div class=\"overflow-x-auto h-[90vh] absolute w-[90vw] left-1/2 -translate-x-1/2 border border-current rounded-2xl bottom-3\"><table class=\"table table-pin-rows table-pin-cols\"><thead><tr class=\"border-current\"><th></th><th>Player 1</th><th>Player 2</th><th>Score</th><th>Difference</th></tr></thead><tbody><tr class=\"border-current\"><th><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 9H4.5a2.5 2.5 0 0 1 0-5H6\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 9h1.5a2.5 2.5 0 0 0 0-5H18\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M4 22h16\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M18 2H6v7a6 6 0 0 0 12 0V2Z\"></path></svg>1st</th><td>Faeq</td><td>John<div class=\"badge badge-accent ml-2\">Winner</div></td><td>3 - 9</td><td>6</td></tr><tr class=\"border-current\"><th><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M11 12 5.12 2.2\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"m13 12 5.88-9.8\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M8 7h8\"></path><circle xmlns=\"http://www.w3.org/2000/svg\" r=\"5\" cy=\"17\" cx=\"12\"></circle><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M12 18v-2h-.5\"></path></svg>2nd</th><td>Faeq</td><td>Mubz<div class=\"badge badge-accent ml-2\">Winner</div></td><td>2 - 20</td><td>18</td></tr></tbody></table></div></div>",
  )
}
