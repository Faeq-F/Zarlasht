//// The director actor - process to manage all games that are being created

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, DequeueParticipant,
  DirectorActorState, EnqueueParticipant, GameStarted, GetParticipants,
  Participants, UpdateParticipant,
}

import gleam/dict.{get}
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/otp/actor.{type Next}

/// Creates the Actor
pub fn start(
  _input: Nil,
  main_subject: Subject(Subject(DirectorActorMessage)),
) -> Result(Subject(DirectorActorMessage), actor.StartError) {
  actor.start_spec(actor.Spec(
    init: fn() {
      let director_subject = process.new_subject()
      process.send(main_subject, director_subject)

      let selector =
        process.new_selector()
        |> process.selecting(director_subject, function.identity)

      actor.Ready(DirectorActorState(dict.new()), selector)
    },
    init_timeout: 1000,
    loop: handle_message,
  ))
}

import app/models/director/game_started.{game_started}
import app/models/director/participants.{
  dequeue_participant, enqueue_participant, update_participant,
}

/// Handles messages from other actors
///
fn handle_message(
  message: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message {
    EnqueueParticipant(game_code, player, participant_subject) ->
      enqueue_participant(game_code, player, participant_subject, state)
      |> actor.continue

    DequeueParticipant(player, game_code) ->
      dequeue_participant(player, game_code, state) |> actor.continue

    UpdateParticipant(player, game_code) ->
      update_participant(player, game_code, state)
      |> actor.continue

    GameStarted(game_code) -> game_started(game_code, state) |> actor.continue

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
