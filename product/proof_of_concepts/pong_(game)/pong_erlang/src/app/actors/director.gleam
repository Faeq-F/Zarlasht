//// The director actor - process to manage all tasks the server carries out

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, DirectorActorState,
  EnqueueUser,
}
import app/actors/game
import carpenter/table
import gleam/dict.{drop, get, insert}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor.{type Next}

/// Creates the Actor
pub fn start() -> Subject(DirectorActorMessage) {
  let assert Ok(actor) = actor.start(DirectorActorState, handle_message)
  actor
}

/// Handles messages from other actors
///
fn handle_message(
  message: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message {
    EnqueueUser(participant_subject) -> {
      game.start(participant_subject)
      state |> actor.continue
    }
  }
}
