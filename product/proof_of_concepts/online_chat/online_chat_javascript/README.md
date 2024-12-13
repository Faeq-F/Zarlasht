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
# Render HTML docs locally (found at /build/dev/docs/online_chat_javascript/)
gleam docs build
# Run all tests
gleam test --target javascript --runtime deno -- test/* ; gleam run & cd ../automated_browser_tests/ && gleam test ; cd ../online_chat_javascript ; pkill deno
# Run just the unit tests
gleam test --target javascript --runtime deno -- test/*
# Run just the unit tests with watching
gleam test --target javascript --runtime deno -- --glacier
# Run just the browser automated tests
gleam run & cd ../automated_browser_tests/ && gleam test ; cd ../online_chat_javascript ; pkill deno
```
