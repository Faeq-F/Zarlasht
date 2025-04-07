import app/actors/actor_types.{
  type BattleActorMessage, type EnemyActorMessage, type EnemyActorState,
  EnemyActorState, EnemyDied, EnemyGotHit, EnemyHit, ExpertSwordsman,
  MakeActions, SetupEnemy, ShutdownEnemy,
}
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/option.{None, Some}
import gleam/otp/actor.{type Next}

/// Creates the actor
///
pub fn start(
  me: String,
  battle: Subject(BattleActorMessage),
) -> Subject(EnemyActorMessage) {
  // set initial state
  let state =
    EnemyActorState(
      battle,
      case me {
        "Expert Swordsman" -> ExpertSwordsman
        //TODO add others
        _ -> ExpertSwordsman
      },
      // TODO - base these values off me aswell
      health: 5,
      strength: 3,
      action: #(0, 0, 0),
      myself: None,
    )
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
    MakeActions -> {
      //randomize sleep - emulate player reading info or some other task
      process.sleep(int.random(3000))
      //roll
      let roll = case int.random(6) {
        //upper is exclusive, 0 is inclusive
        0 -> 6
        number -> number
      }
      let new_state = case state.action {
        #(0, _, _) -> EnemyActorState(..state, action: #(roll, 0, 0))
        #(_, 0, _) ->
          EnemyActorState(..state, action: #(state.action.0, roll, 0))
        #(x, y, _) if x < 4 && y < 4 ->
          EnemyActorState(..state, action: #(
            state.action.0,
            state.action.1 + roll,
            0,
          ))
        #(_, _, 0) ->
          EnemyActorState(..state, action: #(
            state.action.0,
            state.action.1,
            roll,
          ))
        _ ->
          //all filled - hit!
          EnemyActorState(..state, action: #(0, 0, 0))
      }
      //check if need to hit
      case new_state.action {
        #(0, 0, 0) -> {
          //randomize sleep - emulate player reading info or some other task
          process.sleep(int.random(3000))
          process.send(state.battle, EnemyHit(new_state.action, state.strength))
        }
        _ -> Nil
      }
      //loop
      let assert Some(myself) = state.myself
      process.send(myself, MakeActions)
      new_state |> actor.continue
    }
    EnemyGotHit(remove_health) -> {
      let new_health = state.health - remove_health
      //check if dead
      case new_health {
        0 -> {
          process.send(state.battle, EnemyDied)
          actor.Stop(process.Normal)
        }
        _ -> EnemyActorState(..state, health: new_health) |> actor.continue()
      }
    }
    SetupEnemy(myself) -> {
      EnemyActorState(..state, myself: Some(myself)) |> actor.continue
    }
    ShutdownEnemy -> actor.Stop(process.Normal)
  }
}
