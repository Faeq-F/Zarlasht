import automated_browser_tests
import chrobot
import glacier
import glacier/should
import gleam/dynamic
import gleam/io

pub fn main() {
  let assert Ok(_) = automated_browser_tests.main()
  io.println("\nRunning automated browser tests;\n")
  glacier.main()
}

pub fn home_page_test() {
  let assert Ok(browser) = chrobot.launch()
  use <- chrobot.defer_quit(browser)
  let assert Ok(page) =
    browser
    |> chrobot.open("http://localhost:8000", 30_000)
  let assert Ok(_body) = chrobot.await_selector(page, "body")
}
