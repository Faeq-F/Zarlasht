## Setup

Install [Gleam](https://gleam.run/getting-started/installing/)

Install [Deno](https://docs.deno.com/runtime/#install-deno)

Install [Valkey](https://valkey.io/topics/installation/)<br> and place
`SERVICE_URI='127.0.0.1:6379'` in a `.env` file in this folder

Within the `static` folder, you will need a `libraries` folder with the
following:

- `daisyui.min.css`
- `tailwind.min.js`
- `htmx.min.js`
- a folder named `htmx-ext` that contains `ws.js`

## Development & Use

Please run in a linux environment (WSL works), as there are known
[issues on Windows](https://github.com/MystPi/glen/issues/5)

```sh
# Run the project
gleam run
# Render HTML docs locally (found at /build/dev/docs/tictactoe_javascript/)
gleam docs build
# Run all tests
gleam test --target javascript --runtime deno -- test/* ; gleam run & cd ../automated_browser_tests/ && gleam test ; cd ../tictactoe_javascript ; pkill deno
# Run just the unit tests
gleam test --target javascript --runtime deno -- test/*
# Run just the unit tests with watching
gleam test --target javascript --runtime deno -- --glacier
# Run just the browser automated tests
gleam run & cd ../automated_browser_tests/ && gleam test ; cd ../tictactoe_javascript ; pkill deno
```


### Project structure

#### Interesting files
Files that would likely be more interesting;
- sockets.gleam
- state.ffi.mjs
- those in `lib` for their respective actions<br>(mostly sending messages to websockets)

#### Structure

<!-- prettier-ignore-start -->

```
root
├── src
│   ├── lib
|   |   |
|   |   ├── create_game.gleam
|   |   |   (handles creation of a new game)
|   |   |
|   |   ├── game.gleam
|   |   |   (handles game actions like clicking on a box)
|   |   |
|   |   ├── join_game.gleam
|   |   |   (handles joining to a pre-existing game)
|   |   |
|   |   └── set_name.gleam
|   |       (handles setting a user's name & redirection to the game)
|   |
|   ├── pages
|   |   ├── layout.gleam
|   |   |   (The general structure of the pages, including the app div
|   |   |    with which the client requests a websocket connection)
|   |   |
|   |   └── ... (The different pages for the project & their UI elements)
|   |
│   ├── tictactoe_javascript.gleam
|   |   (The entry-point for the program & request handler)
│   │
│   ├── sockets.gleam
│   │   (functions relating to the websocket connection, including
|   |    open, close, and all events)
│   │
│   ├── state.ffi.mjs
│   │   (javascript functions, mostly for managing state;
|   |    util. functions that rely on JS for execution)
│   │
│   ├── state.gleam
│   │   (the FFI for the external util. functions)
│   │
|   └── ... (other files required for setup / execution)
|
├── static
|   ├── libraries
|   |   ├─── htmx-ext
|   |   |   └── ws.js
|   |   |       (the websocket extension for htmx)
|   |   |
|   |   └── ... (other required libraries; detailed in the setup section)
|   └── ... (other required resources, like the favicon)
|
├── test
│   ├── tictactoe_javascript_test.gleam
|   |   (setup for unit tests & base tests for the homepage 
|   |   router and websocket connection)
|   |
|   └── ... (tests for all pages & their functions)
|
├── .env
|   (contains the SERVICE_URI for Valkey)
│
├── gleam.toml (configuration for the project)
|
└── README.md (this file)
```

<!-- prettier-ignore-end -->