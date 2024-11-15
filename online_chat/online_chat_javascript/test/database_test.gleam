import glacier/should
import gleam/dynamic
import gleam/int
import gleam/javascript/promise
import utils.{db_set}

pub fn hello_world_test() {
  let value = int.random(9_999_999)
  db_set("key", dynamic.from(value))
  // promise.await(db_get("key"), fn(result: List(String)) {
  //   result
  //   |> should.equal([int.to_string(value)])
  //   |> promise.resolve
  // })
}
