## Setup

Install [Gleam](https://gleam.run/getting-started/installing/)

Within the `priv/static` folder, you will need a `libraries` folder with the
following:

- `daisyui.min.css`
- `tailwind.min.js`

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
["player"]
```

i.e., the homepage is accessible via http://127.0.0.1:8000/ or
http://127.0.0.1:8000/home<br> (localhost is an alias of 127.0.0.1)
