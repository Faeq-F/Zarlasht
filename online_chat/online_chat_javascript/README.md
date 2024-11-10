## Setup

Within the `static` folder, you will need a `libraries` folder with the
following:

- `daisyui.min.css`
- `tailwind.min.js`
- `htmx.min.js`
- a folder named `htmx-ext` that contains `ws.js`

You will need a Valkey database.

brew install valkey

brew services start valkey

brew services info valkey

brew services stop valkey

SERVICE_URI='127.0.0.1:6379' in .env

## Development

Please run in a linux environment (WSL works), as there are known
[issues on Windows](https://github.com/MystPi/glen/issues/5)

```sh
# Run the project
gleam run
# Run all tests
gleam test --target javascript --runtime deno -- test/* ; gleam run & cd automated_browser_tests/ && gleam test ; cd .. ; pkill deno
# Run just the unit tests
gleam test --target javascript --runtime deno -- test/*
# Run just the unit tests with watching
gleam test --target javascript --runtime deno -- --glacier
# Run just the browser automated tests
gleam run & cd automated_browser_tests/ && gleam test ; cd .. ; pkill deno
```
