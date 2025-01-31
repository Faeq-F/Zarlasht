import chrobot.{type Page}
import glacier
import glacier/should
import gleam/erlang/process
import gleam/pair
import gleam/string
import pong_erlang

/// Function to get around the 'connection isn't private' page that chrome displays when running on localhost with HTTPS
///
/// clicks on the 'Advanced' button and then on the 'continue link'
///
pub fn connection_is_not_private(page: Page) {
  let assert Ok(advanced_button) =
    chrobot.await_selector(page, "#details-button")
  //(an alternative solution found, would be to type 'thisisunsafe' (without clicking on anything))
  let assert Ok(_) = chrobot.click(page, advanced_button)
  let assert Ok(proceed_link) = chrobot.await_selector(page, "#proceed-link")
  let assert Ok(_) = chrobot.click(page, proceed_link)
  Nil
}

pub fn launch_game() {
  // start the browser
  let assert Ok(browser) = chrobot.launch()

  //open the home page
  let assert Ok(page) =
    browser
    |> chrobot.open("https://localhost:8000", 30_000)

  // wait until something has loaded - could be either the connection page or the game
  let assert Ok(_) = chrobot.await_selector(page, "div")
  let assert Ok(all_html) = chrobot.get_all_html(page)
  case string.contains(all_html, "Pong") {
    True -> Nil
    _ -> connection_is_not_private(page)
  }

  pair.new(browser, page)
}

/// Starts the game server in a seperate process, and runs all tests
///
pub fn main() {
  process.start(
    fn() {
      let assert Ok(_) = pong_erlang.main()
    },
    True,
  )
  glacier.main()
}

pub fn connection_test() {
  let #(browser, page) = launch_game()
  use <- chrobot.defer_quit(browser)
  //check for the basic structure - app div that holds everything and triggers the ws connnection
  let assert Ok(app) = chrobot.await_selector(page, "#app")
  let assert Ok(hx_ext) = chrobot.get_attribute(page, app, "hx-ext")
  hx_ext |> should.equal("ws")
  let assert Ok(ws_connect) = chrobot.get_attribute(page, app, "ws-connect")
  ws_connect |> should.equal("/init_socket")
}
