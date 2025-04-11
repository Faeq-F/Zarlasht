//// The handler for a user disconnecting in a game

import app/actors/actor_types.{
  type GameActorState, type Player, GameActorState, Player,
}
import gleam/list

/// The handler for the UserDisconnected message
///
pub fn user_disconnected(player: Player, state: GameActorState) {
  //let other players know - custom message (health retreated, scared, etc.)
  //remove from state
  GameActorState(..state, participants: {
    state.participants
    |> list.filter(fn(participant) { { participant.0 }.number != player.number })
  })
}
