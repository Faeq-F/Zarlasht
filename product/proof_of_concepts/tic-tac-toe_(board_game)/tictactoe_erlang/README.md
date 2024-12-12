# tictactoe_erlang

[![Package Version](https://img.shields.io/hexpm/v/tictactoe_erlang)](https://hex.pm/packages/tictactoe_erlang)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/tictactoe_erlang/)

```sh
gleam add tictactoe_erlang@1
```

```gleam
import tictactoe_erlang

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/tictactoe_erlang>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/#why-https-locally

myCA.key (your private key) and myCA.pem (your root certificate) in ~/certs/

Commands Ran:

openssl genrsa -des3 -out myCA.key 2048

openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem

need key & certificate for https;

openssl genrsa -out tictactoe.key 2048

openssl req -new -key tictactoe.key -out tictactoe.csr

openssl x509 -req -in tictactoe.csr -CA ~/certs/myCA.pem -CAkey ~/certs/myCA.key
\ -CAcreateserial -out tictactoe.crt -days 825 -sha256 -extfile tictactoe.ext

tictactoe.ext:

```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = tictactoe
```
