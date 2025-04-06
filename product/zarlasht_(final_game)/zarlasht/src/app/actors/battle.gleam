//// The battle actor - process to manage a battle occurring in a game

import app/actors/actor_types.{
  type BattleActorMessage, type BattleActorState, type BattleType,
  type DirectorActorMessage, type DirectorActorState, type GameActorMessage,
  AddPlayer, Ambush, BattleActorState, Cemetary, Demon, DequeueParticipant,
  DirectorActorState, EnemyTribe, EnqueueParticipant, GameStarted,
  GetParticipants, JoinGame, Participants, PrepareGame, Ravine, SendToClient,
  SetupBattle, UpdateParticipant,
}

import app/pages/game as game_page
import carpenter/table
import gleam/dict.{drop, get, insert}
import gleam/dynamic.{type Dynamic}
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/otp/actor.{type Next}
import logging.{Info}

import app/actors/enemy

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
  message_for_actor: BattleActorMessage,
  state: BattleActorState,
) -> Next(BattleActorMessage, BattleActorState) {
  logging.log(
    Info,
    "Battle Actor" <> int.to_string(state.id) <> " got the message",
  )
  io.debug(message_for_actor)
  case message_for_actor {
    SetupBattle(id, game) -> {
      case state.battle_type {
        Ravine(w_type) | EnemyTribe(w_type) | Ambush(w_type) -> {
          enemy.start(w_type)
          Nil
        }
        Demon | Cemetary -> {
          //predefined warrior types
          //should be DemonicSpirit and Ghost / Zombie (randomize between the two)
          //TODO - for now - swordsman
          enemy.start("")
          Nil
        }
        _ -> {
          //its fog - TODO - battle other player
          Nil
        }
      }
      BattleActorState(..state, id: id, game: Some(game)) |> actor.continue
    }
  }
}
