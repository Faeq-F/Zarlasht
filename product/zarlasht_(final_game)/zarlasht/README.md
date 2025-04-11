## Setup

Install [Gleam](https://gleam.run/getting-started/installing/)

Add icons via `gleam run -m lucide_lustre/add_all`

Install [Valkey](https://valkey.io/topics/installation/)<br> and place
`SERVICE_URI='127.0.0.1:6379'` in a `.env` file in this folder

Within the `static` folder, you will need a `libraries` folder with the
following:

- `daisyui.min.css`
- `tailwind.min.js`
- `htmx.min.js`
- a folder named `htmx-ext` that contains `ws.js`

<details><summary>You will also need a certificate to run the server using HTTPS</summary>

To do this you will need to
[become a CA](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/#why-https-locally);

```sh
# Generate your private key
openssl genrsa -des3 -out myCA.key 2048
# Your root certificate
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
```

Then make a zarlasht.ext file, with the following contents;

```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = zarlasht
```

Then you will need to generate the site's key and certificate;

```sh
#Key
openssl genrsa -out zarlasht.key 2048
openssl req -new -key zarlasht.key -out zarlasht.csr
#Certificate
openssl x509 -req -in zarlasht.csr -CA ~/certs/myCA.pem -CAkey ~/certs/myCA.key \
-CAcreateserial -out zarlasht.crt -days 825 -sha256 -extfile zarlasht.ext
```

</details>

## Development & Use

```sh
# Run the project
gleam run
# Render HTML docs locally (found at /build/dev/docs/zarlasht/)
gleam docs build
# Run all tests - needs editing
gleam test ; gleam run & cd ../automated_browser_tests/ && gleam test ; cd ../zarlasht ; pkill deno
# Run just the unit tests
gleam test
# Run just the unit tests with watching
gleam test -- --glacier
# Run just the browser automated tests - needs editing
gleam run & cd ../automated_browser_tests/ && gleam test ; cd ../zarlasht ; pkill deno
```



### Project structure

#### Interesting files
Files that would likely be more interesting;
- game.gleam
- director.gleam
- websocket.gleam
- those in `lib` for their respective actions<br>(mostly passing messages between the actors)

#### Structure

<!-- prettier-ignore-start -->

```
root
├── src
│   ├── app
|   |   ├── actors
|   |   |   ├── actor_types.gleam
|   |   |   |   (The types defining the actors' states and custom messages)
|   |   |   |
|   |   |   ├── director.gleam
|   |   |   |   (The actor that handles the addition and removal of clients in
|   |   |   |    games)
|   |   |   |
|   |   |   ├── game.gleam
|   |   |   |   (The actor that handles an individual game)
|   |   |   |
|   |   |   └── websocket.gleam
|   |   |       (The actor that handles the connection between the client and 
|   |   |        server with a websocket, utilizing the handlers in lib)
|   |   |
|   |   ├── lib
|   |   |   | (most pass messages to the director or game actors)
|   |   |   |
|   |   |   ├── create_game.gleam
|   |   |   |   (handles creation of a new game)
|   |   |   |
|   |   |   ├── join_game.gleam
|   |   |   |   (handles joining to a pre-existing game)
|   |   |   |
|   |   |   └── name_set.gleam
|   |   |       (handles setting a user's name & redirection to the game)
|   |   |
|   |   ├── pages
|   |   |   ├── components
|   |   |   |   ├── lucide_lustre.gleam
|   |   |   |   |   (Added through the command provided in the setup section;
|   |   |   |   |    all icons in the lucide icon pack, for use within pages)
|   |   |   |   |
|   |   |   |   └── ... (other UI elements, for use within pages)
|   |   |   |
|   |   |   ├── layout.gleam
|   |   |   |   (The general structure of the pages, including the app div
|   |   |   |    with which the client requests a websocket connection)
|   |   |   |
|   |   |   └── ... (The different pages for the project & their UI elements)
|   |   |   
|   |   |
|   |   ├── router.gleam
|   |   |   (The request handler for the web server & helper
|   |   |    functions, like get_content_type for resources)
|   |   |
|   |   └── web.gleam
│   │       (middleware for the web server,
|   |        like logging and default responses)
│   │
│   ├── zarlasht.gleam
│   │   (The entry-point for the program; sets up
│   │    essentials like logging and starts the web server)
│   │
│   └── valkey.gleam
|       (Code relating to using the Valkey database,
|       including the subscriber and client processes)
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
│   ├── zarlasht_test.gleam
|   |   (setup for unit tests)
|   |
|   └── ... (tests for all pages & their functions)
|
├── .env
|   (contains the SERVICE_URI & SERVICE_PORT for Valkey)
│
├── zarlasht.crt
├── zarlasht.csr
├── zarlasht.ext
├── zarlasht.key
|   (Required for running the web server with https;
|    instructions for creating these are in the setup section)
│
├── gleam.toml (configuration for the project)
|
└── README.md (this file)
```

<!-- prettier-ignore-end -->