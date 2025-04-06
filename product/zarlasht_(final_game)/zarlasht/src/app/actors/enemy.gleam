import app/actors/actor_types.{
  type EnemyActorMessage, type EnemyActorState, type EnemyType, EnemyActorState,
  ExpertSwordsman,
}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor.{type Next}

/// Creates the actor
///
pub fn start(me: String) -> Subject(EnemyActorMessage) {
  // set initial state
  let state =
    EnemyActorState(case me {
      "Expert Swordsman" -> ExpertSwordsman
      //TODO add others
      _ -> ExpertSwordsman
    })
  let assert Ok(actor) = actor.start(state, handle_message)
  actor
}

/// Handles messages from other actors
///
fn handle_message(
  message: EnemyActorMessage,
  state: EnemyActorState,
) -> Next(EnemyActorMessage, EnemyActorState) {
  case message {
    _ -> {
      todo
    }
  }
}
