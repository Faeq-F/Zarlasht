import app/actors/actor_types.{DownHit, EnterHit, SHit, UpHit, WHit}

import gleam/erlang/process
import gleam/option.{Some}

pub fn on_enter(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, EnterHit(message))
}

pub fn on_w(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, WHit(message))
}

pub fn on_s(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, SHit(message))
}

pub fn on_up(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, UpHit(message))
}

pub fn on_down(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, DownHit(message))
}
