import app/router
import app/web.{Context}
import glacier
import glacier/should
import wisp/testing

pub fn main() {
  glacier.main()
}

pub fn hello_world_test() {
  let ctx = Context("priv/static/")
  let response = router.handle_request(testing.get("/", []), ctx)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "text/html; charset=utf-8")])

  response
  |> testing.string_body
  |> should.equal("<h1>Hello, Joe!</h1>")
}
