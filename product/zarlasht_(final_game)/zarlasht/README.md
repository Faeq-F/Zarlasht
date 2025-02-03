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
