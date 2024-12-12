import glacier/should
import gleam/int
import socket_state.{SendMessage, State}

pub fn state_test() {
  let state = State(56_789, "John")

  state.username
  |> should.equal("John")

  state.chat_code
  |> should.equal(56_789)
}

pub fn random_state_test() {
  let code = int.random(9999)
  let username = int.random(123_456_789) |> int.to_string
  let state = State(code, username)

  state.username
  |> should.equal(username)

  state.chat_code
  |> should.equal(code)
}

pub fn event_test() {
  SendMessage
  |> should.equal(SendMessage)
}
