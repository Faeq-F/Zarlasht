import glacier
import glacier/should
import gleam/fetch
import gleam/http/request
import gleam/http/response
import gleam/javascript/promise
import tictactoe_javascript

pub fn main() {
  glacier.main()
  tictactoe_javascript.main()
}

pub fn home_page_test() {
  let assert Ok(req) = request.to("http://localhost:8000")

  // Send the HTTP request to the server
  use resp <- promise.try_await(fetch.send(req))
  use resp <- promise.try_await(fetch.read_text_body(resp))

  // We get a response record back
  should.equal(resp.status, 200)
  should.equal(response.get_header(resp, "content-type"), Ok("text/html"))
  should.equal(
    resp.body,
    "<!doctype html>\n<html lang=\"en\" data-theme=\"emerald\"><head><title>Tic-Tac-Toe</title><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><link href=\"/static/favicon.png\" type=\"image/x-icon\" rel=\"icon\"><link href=\"https://fonts.googleapis.com\" rel=\"preconnect\"><link crossorigin href=\"https://fonts.gstatic.com\" rel=\"preconnect\"><link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css2?family=Varela+Round&amp;display=swap\"><link rel=\"stylesheet\" href=\"/static/pages/app.css\"><script src=\"/static/libraries/htmx.min.js\"></script><script src=\"/static/libraries/htmx-ext/ws.js\"></script><script src=\"/static/libraries/tailwind.min.js\"></script><link rel=\"stylesheet\" href=\"/static/libraries/daisyui.min.css\"><link rel=\"stylesheet\" href=\"/static/app.css\"><style type=\"text/tailwindcss\">\n          .btn {\n            @apply rounded-full;\n          }\n        </style><script>tailwind.config = {\n            daisyui: {\n              darkTheme: 'forest',\n            }\n          }</script></head><body><label class=\"swap swap-rotate right-0 fixed m-4 z-10\"><input value=\"forest\" type=\"checkbox\" class=\"theme-controller hidden\"><svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\" class=\"swap-off h-10 w-10 fill-current\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z\"></path></svg><svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\" class=\"swap-on h-10 w-10 fill-current\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z\"></path></svg></label><label class=\"left-0 m-4 fixed z-10\"><a href=\"https://github.com/faeq-f/tic-tac-toe\" rel=\"noopener noreferrer\" target=\"_blank\"><svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\" xmlns=\"http://www.w3.org/2000/svg\" class=\"fill-current\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z\"></path></svg></a></label><label class=\"left-0 bottom-0 fixed m-4 z-10\"><p>Created by <a href=\"https://faeq-f.github.io/\" rel=\"noopener noreferrer\" target=\"_blank\" class=\"text-accent\">Faeq</a></p></label><div ws-connect=\"/init_socket\" hx-ext=\"ws\" id=\"app\"><script>window.onbeforeunload = function() {return true;};</script><div id=\"page\"><div class=\"hero bg-base-100 min-h-full\"><div class=\"hero-content text-center absolute top-1/2 -translate-y-1/2\"><div class=\"max-w-md\"><h1 class=\"text-5xl font-bold mb-3\">Tic-Tac-Toe</h1><div id=\"pageInputs\" class=\"join\"><button ws-send id=\"create\" data-theme=\"forest\" class=\"btn join-item bg-secondary text-secondary-content hover:bg-accent\">Create a game</button><button ws-send id=\"join\" data-theme=\"forest\" class=\"btn join-item bg-neutral hover:bg-accent hover:text-secondary-content\">Join a game</button></div></div></div></div></div></div></body></html>",
  )

  promise.resolve(Ok(Nil))
}

pub fn not_found_test() {
  let assert Ok(req) =
    request.to("http://localhost:8000/this-page-does-not-exist")

  // Send the HTTP request to the server
  use resp <- promise.try_await(fetch.send(req))
  use resp <- promise.try_await(fetch.read_text_body(resp))

  // We get a response record back
  should.equal(resp.status, 404)
  should.equal(response.get_header(resp, "content-type"), Ok("text/html"))
  should.equal(
    resp.body,
    "<h1>Oops, are you lost?</h1>\n  <p>This page doesn't exist.</p>",
  )

  promise.resolve(Ok(Nil))
}

pub fn init_socket_test() {
  let assert Ok(req) = request.to("http://localhost:8000/init_socket")

  // Send the HTTP request to the server
  use resp <- promise.try_await(fetch.send(req))
  use resp <- promise.try_await(fetch.read_text_body(resp))

  // 426 = 'upgrade required'
  should.equal(resp.status, 426)
  should.equal(response.get_header(resp, "upgrade"), Ok("websocket"))
  should.equal(resp.body, "")

  promise.resolve(Ok(Nil))
}
