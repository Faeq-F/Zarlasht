import automated_browser_tests
import chrobot
import chrobot/protocol/network
import chrobot/protocol/runtime
import glacier
import glacier/should
import gleam/dynamic
import gleam/io
import gleam/option.{Some}

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

pub fn sent_websocket_messages_test() {
  // start the browser
  let assert Ok(browser) = chrobot.launch()
  use <- chrobot.defer_quit(browser)

  //open the home page
  let assert Ok(page) =
    browser
    |> chrobot.open("http://localhost:8000", 30_000)
  let callback = chrobot.page_caller(page)
  // wait for relevant body to load
  let assert Ok(_) = chrobot.await_selector(page, "#pageInputs")

  //start checks
  let _ = network.enable(callback, Some(134_200_000))
  let _ = runtime.enable(callback)

  // Inject JavaScript to monitor WebSocket messages and send them to Gleam
  let script =
    "
    document.body.addEventListener('htmx:wsAfterSend', function (evt) {
      window.gleamWebSocketMessage = evt.detail.message;
    });
    "
  let assert Ok(_) =
    runtime.evaluate(
      callback,
      script,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
    )

  //click on the join button and check the message it sends
  let assert Ok(join_input) = chrobot.await_selector(page, "#join")
  let assert Ok(_) = chrobot.click(page, join_input)

  let assert Ok(message) =
    runtime.evaluate(
      callback,
      "window.gleamWebSocketMessage",
      option.None,
      option.None,
      option.None,
      option.None,
      //option.None,
      Some(True),
      option.None,
      option.None,
    )

  let assert Ok(message_value) =
    option.to_result(message.result.value, "Could not obtain message value")
  let assert Ok(value) =
    message_value
    |> dynamic.string
  value
  |> should.equal(
    "{\"HEADERS\":{\"HX-Request\":\"true\",\"HX-Trigger\":\"join\",\"HX-Trigger-Name\":null,\"HX-Target\":\"join\",\"HX-Current-URL\":\"http://localhost:8000/\"}}",
  )

  //click on the create button and check the message it sends
  let assert Ok(create_input) = chrobot.await_selector(page, "#create")
  let assert Ok(_) = chrobot.click(page, create_input)

  let assert Ok(message) =
    runtime.evaluate(
      callback,
      "window.gleamWebSocketMessage",
      option.None,
      option.None,
      option.None,
      option.None,
      //option.None,
      Some(True),
      option.None,
      option.None,
    )

  let assert Ok(message_value) =
    option.to_result(message.result.value, "Could not obtain message value")
  let assert Ok(value) =
    message_value
    |> dynamic.string
  value
  |> should.equal(
    "{\"HEADERS\":{\"HX-Request\":\"true\",\"HX-Trigger\":\"create\",\"HX-Trigger-Name\":null,\"HX-Target\":\"create\",\"HX-Current-URL\":\"http://localhost:8000/\"}}",
  )
}
