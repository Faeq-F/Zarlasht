//// The director actor - process to manage all tasks the server carries out

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, AddPlayer,
  DequeueParticipant, DirectorActorState, EnqueueParticipant, GetParticipants,
  Participants,
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
        Ok(game) -> {
          //They are joining a Game
          process.send(game.0, AddPlayer(participant))
          state.games_waiting
          |> insert(game_code, #(game.0, [participant, ..game.1]))
        }
        _ -> {
          //They created the game
          let game_subject = game.start(game_code, [participant])
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
      //state.games_waiting |> drop([game_code])
      state |> actor.continue
    }
    GetParticipants(asker, game_code) -> {
      let participants = case state.games_waiting |> get(game_code) {
        Ok(game) -> game.1
        _ -> []
      }
      process.send(asker, Participants(participants))
      state |> actor.continue
    }
  }
}
