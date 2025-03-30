//// The battle actor - process to manage a battle occurring in a game

import app/actors/actor_types.{
  type BattleActorMessage, type BattleActorState, type BattleType,
  type DirectorActorMessage, type DirectorActorState, type GameActorMessage,
  AddPlayer, BattleActorState, DequeueParticipant, DirectorActorState,
  EnqueueParticipant, GameStarted, GetParticipants, JoinGame, Participants,
  PrepareGame, SendToClient, SetupBattle, UpdateParticipant,
}

import app/pages/game as game_page
import carpenter/table
import gleam/dict.{drop, get, insert}
import gleam/dynamic.{type Dynamic}
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/otp/actor.{type Next}

/// Creates the Actor
pub fn start(
  battle_type: BattleType,
  game_subject: Subject(Subject(BattleActorMessage)),
) -> Result(process.Pid, Dynamic) {
  actor.start_spec(actor.Spec(
    init: fn() {
      let battle_subject = process.new_subject()
      process.send(game_subject, battle_subject)

      let selector =
        process.new_selector()
        |> process.selecting(battle_subject, function.identity)

      actor.Ready(BattleActorState(0, None, battle_type), selector)
    },
    init_timeout: 1000,
    loop: handle_message,
  ))
  |> actor.to_erlang_start_result
}

/// Handles messages from other actors
///
fn handle_message(
  message: BattleActorMessage,
  state: BattleActorState,
) -> Next(BattleActorMessage, BattleActorState) {
  case message {
    SetupBattle(id, game) -> {
      BattleActorState(..state, id: id, game: Some(game)) |> actor.continue
    }
  }
}
