import Valkey from "npm:ioredis";
import "jsr:@std/dotenv/load";

const valkey = new Valkey(Deno.env.get("SERVICE_URI"));

//need to test this & await all
function ffi_get_json_value(json_string, key) {
  const val = JSON.parse(json_string)[key] + "";
  if (val === "[object Object]") {
    return JSON.stringify(JSON.parse(json_string)[key]);
  } else {
    return val;
  }
}

async function ffi_db_set(key, value) {
  valkey.set(key, value);
}

async function ffi_db_get(key) {
  let value;
  await valkey.get(key).then(function (result) {
    value = result
  });
  return value;
}

export {
  ffi_get_json_value, ffi_db_set, ffi_db_get
};
