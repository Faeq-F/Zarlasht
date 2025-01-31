//// User actions when playing the game

import app/actors/actor_types.{DownHit, EnterHit, Leaderboard, SHit, UpHit, WHit}
import gleam/erlang/process
import gleam/option.{Some}
import lustre/attribute
import lustre/element
import lustre/element/html
import mist

/// Called when the user hits the enter key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_enter(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, EnterHit(message))
}

/// Called when the user hits the W key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_w(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, WHit(message))
}

/// Called when the user hits the S key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_s(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, SHit(message))
}

/// Called when the user hits the up_arrow key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_up(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, UpHit(message))
}

/// Called when the user hits the down_arrow key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_down(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, DownHit(message))
}

/// Called when the user hits the trophy button
///
/// Lets the director actor know so that it can assemble and display it to the user
///
pub fn show_leaderboard(player: actor_types.PlayerSocket) {
  process.send(
    player.state.director_subject,
    Leaderboard(player.state.ws_subject),
  )
  player.state
}

/// Called when the user hits the cross when viewing the leaderboard overlay
///
/// closes the overlay
///
pub fn close_leaderboard(player: actor_types.PlayerSocket) {
  let assert Ok(_) = mist.send_text_frame(player.socket, empty_leaderboard())
  player.state
}

///The overlay div, emptied, so that the user is no longer looking at the leaderboard
///
fn empty_leaderboard() {
  html.div([attribute.id("overlay")], []) |> element.to_string
}
