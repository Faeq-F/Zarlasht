## Setup

Within the `static` folder, you will need a `libraries` folder with the following:
- `daisyui.min.css`
- `tailwind.min.js`
- `htmx.min.js`
- a folder named `htmx-ext` that contains `ws.js`

## Development

```sh
gleam run                                                   # Run the project
gleam test --target javascript --runtime deno -- --glacier  # Run the tests
```
