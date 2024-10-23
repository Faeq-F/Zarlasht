function ffi_get_json_value(json_string, key) {
  const val = JSON.parse(json_string)[key] + "";
  if (val === "[object Object]") {
    return JSON.stringify(JSON.parse(json_string)[key]);
  } else {
    return val;
  }
}

export {
  ffi_get_json_value,
};
