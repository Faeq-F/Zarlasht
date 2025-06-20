import app/pages/set_name.{empty_name, set_name_page, waiting}
import glacier/should

pub fn empty_name_test() {
  empty_name()
  |> should.equal(
    "<div id=\"waiting\"><p class=\"text-sm mt-1 text-error\">You cannot have an empty name!</p></div>",
  )
}

pub fn set_name_page_test() {
  set_name_page()
  |> should.equal(
    "<div id=\"page\" class=\"hero bg-base-100 min-h-full\"><h1 class=\"text-5xl font-bold mt-4 fixed top-0\">Pong</h1><div class=\"hero-content text-center absolute top-1/2 -translate-y-1/2\"><form ws-send id=\"set-name-form\"><div class=\"grid grid-cols-2 gap-10 w-full h-full\"><div class=\"card text-center h-full\"><div class=\"max-w-md\"><p class=\"font-bold text-3xl mb-3\">Player 1 name</p><input name=\"name1\" placeholder=\"Your name\" class=\"input input-bordered join-item\"></div></div><div class=\"card text-center h-full\"><div class=\"max-w-md\"><p class=\"font-bold text-3xl mb-3\">Player 2 name</p><input name=\"name2\" placeholder=\"Your name\" class=\"input input-bordered join-item\"></div></div></div><button class=\"btn  bg-secondary text-secondary-content hover:bg-accent\"><svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\" class=\"w-5 h-5 \"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M20 6 9 17l-5-5\"></path></svg></button><div id=\"waiting\"></div></form></div></div>",
  )
}

pub fn waiting_test() {
  waiting()
  |> should.equal(
    "<div id=\"waiting\"><p class=\"text-sm mt-1 text-info\">Waiting for the other player...</p></div>",
  )
}
