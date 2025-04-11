## Setup

Install [Gleam](https://gleam.run/getting-started/installing/)

Within the `priv/static` folder, you will need a `libraries` folder with the
following:


- `tailwind.min.js`

v4 tailwind required
require alpine js v3

## Development

```sh
# Run the project
gleam run
```

## Use

Pages are accessible via the following `path_segments`:

```gleam
[] | ["home"]
["created_game"]
["join_game"]
["set_name"]
["game"]
["roll_die"]
["chat"]
["map"]
```

i.e., the homepage is accessible via http://127.0.0.1:8000/ or
http://127.0.0.1:8000/home<br> (localhost is an alias of 127.0.0.1)


### Project structure

#### Interesting files
Files that would likely be more interesting;
- leaderboard.gleam
- game.gleam
- others for their respective components / pages

#### Structure

<!-- prettier-ignore-start -->

```
root
├── src
│   ├── components
|   |   ├── lucide_lustre.gleam
|   |   |   (Added through the command provided in the setup section;
|   |   |    all icons in the lucide icon pack, for use within pages)
|   |   |
|   |   └── ... (other UI elements, for use within pages)
│   │
│   ├── screen_designs.gleam
|   |   (The entry-point for the program; the web server
|   |    and it's request handler)
│   │
│   ├── layout.gleam
|   |   (The general structure of the pages, including the app div
|   |    with which the client requests a websocket connection)
|   |
|   └── ... (The different pages for the project)
|
├── priv
|   └── static
|       ├── libraries
|       |   ├── htmx-ext
|       |   |   └── ws.js
|       |   |       (the websocket extension for htmx)
|       |   |
|       |   └── ... (other required libraries; detailed in the setup section)
|       └── ... (other required resources, like the favicon)
│
├── gleam.toml (configuration for the project)
|
└── README.md (this file)
```

<!-- prettier-ignore-end -->