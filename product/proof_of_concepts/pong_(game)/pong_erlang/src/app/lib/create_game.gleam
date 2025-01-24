//// Game creation

import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueUser, WebsocketActorState,
}

import gleam/erlang/process

/// Creates a new game & updates the WebSocket state
///
pub fn on_create_game(player: PlayerSocket) -> WebsocketActorState {
  process.send(
    player.state.director_subject,
    EnqueueUser(player.state.ws_subject),
  )
  player.state
}
