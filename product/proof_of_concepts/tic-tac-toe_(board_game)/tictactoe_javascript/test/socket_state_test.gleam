import glacier/should
import gleam/int
import socket_state.{Mark, State}

pub fn state_test() {
  let state = State(56_789, "X")

  state.player
  |> should.equal("X")

  state.game_code
  |> should.equal(56_789)
}

pub fn random_state_test() {
  let code = int.random(9999)

  let state = State(code, "O")

  state.player
  |> should.equal("O")

  state.game_code
  |> should.equal(code)
}

pub fn event_test() {
  Mark
  |> should.equal(Mark)
}
