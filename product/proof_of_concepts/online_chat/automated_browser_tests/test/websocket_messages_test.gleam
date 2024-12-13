import chrobot
import chrobot/protocol/network
import chrobot/protocol/runtime
import glacier/should
import gleam/dynamic
import gleam/option.{Some}

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
