//// The director actor - process to manage all tasks the server carries out

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, DequeueParticipant,
  DirectorActorState, EnqueueParticipant,
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
    EnqueueParticipant(game_code, player, participant_subject) -> {
      let participant = #(player, participant_subject)

      let new_queue = case state.games_waiting |> get(game_code) {
        Ok(participants) -> {
          //They are joining a Game
          //game.start([participant, ..participants]) - instead send 'added player'
          //state.games_waiting |> drop([game_code]) - need new message for this
          state.games_waiting
        }
        _ -> {
          //They created the game
          let game_subject = game.start([participant])
          state.games_waiting
          |> insert(game_code, #(game_subject, [participant]))
        }
      }

      DirectorActorState(games_waiting: new_queue) |> actor.continue
    }
    DequeueParticipant(game_code) -> {
      state.games_waiting |> drop([game_code])
      //if array is 1 before drop of player
      // let assert Ok(waiting_games) = table.ref("waiting_games")
      // waiting_games |> table.delete(game_code)
      state |> actor.continue
    }
  }
}
