import app/actors/actor_types.{DownHit, EnterHit, Leaderboard, SHit, UpHit, WHit}
import gleam/erlang/process
import gleam/option.{Some}
import lustre/attribute
import lustre/element
import lustre/element/html
import mist

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

pub fn show_leaderboard(player: actor_types.PlayerSocket) {
  process.send(
    player.state.director_subject,
    Leaderboard(player.state.ws_subject),
  )
  player.state
}

pub fn close_leaderboard(player: actor_types.PlayerSocket) {
  let assert Ok(_) = mist.send_text_frame(player.socket, empty_leaderboard())
  player.state
}

fn empty_leaderboard() {
  html.div([attribute.id("overlay")], []) |> element.to_string
}
