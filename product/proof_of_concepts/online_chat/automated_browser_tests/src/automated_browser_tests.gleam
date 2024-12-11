import chrobot
import gleam/io

pub fn main() {
  io.println("Chrobot setup;")
  // Required to fix chrobot timeout errors when running the tests for the first time
  let assert Ok(browser) = chrobot.launch()
  let assert Ok(_) = chrobot.quit(browser)
}
