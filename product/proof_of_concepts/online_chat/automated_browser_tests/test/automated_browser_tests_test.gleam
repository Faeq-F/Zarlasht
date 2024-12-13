import automated_browser_tests
import chrobot
import glacier
import glacier/should
import gleam/io

pub fn main() {
  let assert Ok(_) = automated_browser_tests.main()
  io.println("\nRunning automated browser tests;\n")
  glacier.main()
}

pub fn home_layout_test() {
  // start the browser
  let assert Ok(browser) = chrobot.launch()
  use <- chrobot.defer_quit(browser)

  //open the home page
  let assert Ok(page) =
    browser
    |> chrobot.open("http://localhost:8000", 30_000)

  //check for the basic structure - app div that holds everything and triggers the ws connnection
  let assert Ok(app) = chrobot.await_selector(page, "#app")
  let assert Ok(hx_ext) = chrobot.get_attribute(page, app, "hx-ext")
  hx_ext |> should.equal("ws")
  let assert Ok(ws_connect) = chrobot.get_attribute(page, app, "ws-connect")
  ws_connect |> should.equal("/init_socket")

  //check for page div with relevant page contents
  let assert Ok(_) = chrobot.await_selector(page, "#page")
  let assert Ok(_) = chrobot.await_selector(page, "#pageInputs")

  let assert Ok(create_input) = chrobot.await_selector(page, "#create")
  let assert Ok(create_ws_send) =
    chrobot.get_attribute(page, create_input, "ws-send")
  create_ws_send |> should.equal("")
  let assert Ok(create_text) = chrobot.get_text(page, create_input)
  create_text |> should.equal("Create a chat")

  let assert Ok(join_input) = chrobot.await_selector(page, "#join")
  let assert Ok(join_ws_send) =
    chrobot.get_attribute(page, join_input, "ws-send")
  join_ws_send |> should.equal("")
  let assert Ok(join_text) = chrobot.get_text(page, join_input)
  join_text |> should.equal("Join a chat")
}
