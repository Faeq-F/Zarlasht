import gleam/javascript/promise.{type Promise}
import glen.{type Request, type Response}
import glen/status
import pages/home.{home_page}
import sockets.{init_socket}

pub fn main() {
  glen.serve(8000, handle_req)
}

fn handle_req(req: Request) -> Promise(Response) {
  // Log all requests and responses
  use <- glen.log(req)
  // Handle potential crashes gracefully
  use <- glen.rescue_crashes
  // Serve static files from ./static on the path /static
  use <- glen.static(req, "static", "./static")

  case glen.path_segments(req) {
    [] -> home_page(req)
    ["init_socket"] -> init_socket(req)
    _ -> not_found(req)
  }
}

pub fn not_found(_req: Request) -> Promise(Response) {
  "<h1>Oops, are you lost?</h1>
  <p>This page doesn't exist.</p>"
  |> glen.html(status.not_found)
  |> promise.resolve
}
