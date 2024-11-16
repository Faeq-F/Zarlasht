import glacier/should
import utils.{get_json_value}

pub fn hello_world_test() {
  get_json_value("{\"hello\":\"world\"}", "hello")
  |> should.equal("world")
}

pub fn nested_test() {
  let htmx_json =
    "{\"HEADERS\":{\"HX-Request\":\"true\",\"HX-Trigger\":\"create\",\"HX-Trigger-Name\":null,\"HX-Target\":\"create\",\"HX-Current-URL\":\"http://localhost:8000/\"}}"
  get_json_value(get_json_value(htmx_json, "HEADERS"), "HX-Trigger")
  |> should.equal("create")
}

pub fn pubsub_test() {
  todo
}
