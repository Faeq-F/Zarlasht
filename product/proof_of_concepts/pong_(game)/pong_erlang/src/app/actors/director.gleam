//// The director actor - process to manage all tasks the server carries out

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, DequeueUser,
  DirectorActorState, EnqueueUser,
}
import app/actors/game
import carpenter/table
import gleam/dict.{drop, get, insert}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor.{type Next}

/// Creates the Actor
pub fn start() -> Subject(DirectorActorMessage) {
  let assert Ok(actor) =
    actor.start(DirectorActorState(dict.new()), handle_message)
  actor
}

/// Handles messages from other actors
///
fn handle_message(
  message: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message {
    EnqueueUser(game_code, participant_subject) -> {
      game.start(participant_subject)
      let new_queue = state.games |> insert(game_code, participant_subject)
      let new_state = DirectorActorState(games: new_queue)
      new_state |> actor.continue
    }
    DequeueUser(game_code) -> {
      state.games |> drop([game_code])
      let assert Ok(games) = table.ref("games")
      games |> table.delete(game_code)
      state |> actor.continue
    }
  }
}
