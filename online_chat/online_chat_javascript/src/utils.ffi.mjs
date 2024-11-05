//// This file represents a single websocket server, alongside app.ts

import Valkey from "npm:ioredis";
import "jsr:@std/dotenv/load";

// Data ════════════════════════════════════════════════════════════════════════

// Map chat_codes to sockets connected to the server
const sockets = new Map();

// seperate valkey connnections as we may want to pub/sub on the same channel
const valkey = new Valkey(Deno.env.get("SERVICE_URI")); // connection for standard tasks (set, get, etc.)
const valkeySub = new Valkey(Deno.env.get("SERVICE_URI")); // connection for subscribing to channels
const valkeyPub = new Valkey(Deno.env.get("SERVICE_URI")); // connection for publishing to channels

valkeySub.on("message", (channel, message) => {
  console.log(`Received ${message} from ${channel}`);
  const chat_sockets = sockets.get(channel);
  for (socket in chat_sockets) {
    console.log(`Socket used message`);
  }
});

// Utils ═══════════════════════════════════════════════════════════════════════

async function ffi_db_set(key, value) {
  valkey.set(key, value);
}

async function ffi_db_get(key) {
  return await valkey.get(key);
}

async function ffi_valkey_publish(channel, message) {
  valkeyPub.publish(channel, message);
}

async function ffi_valkey_subscribe(channel, socket) {
  if (!sockets.has(channel)) {
    valkeySub.subscribe(channel, (err, count) => {
      if (err) {
        console.error("Failed to subscribe: %s", err.message);
      } else {
        console.log(
          `Subscribed successfully! This client is currently subscribed to ${count} channels (chats).`,
        );
      }
    });
  }
  // managing server state
  const old_sockets = sockets.get(channel);
  if (old_sockets === undefined) {
    sockets.set(channel, [socket]);
  } else {
    sockets.set(channel, [...old_sockets, socket]);
  }
}

// Other Utils ═════════════════════════════════════════════════════════════════

function ffi_get_json_value(json_string, key) {
  const val = JSON.parse(json_string)[key] + "";
  if (val === "[object Object]") {
    return JSON.stringify(JSON.parse(json_string)[key]);
  } else {
    return val;
  }
}

// ═════════════════════════════════════════════════════════════════════════════

export {
  ffi_db_get,
  ffi_db_set,
  ffi_get_json_value,
  ffi_valkey_publish,
  ffi_valkey_subscribe,
};
