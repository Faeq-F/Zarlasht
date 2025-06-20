//// The battle actor - process to manage a battle occurring in a game

import app/actors/actor_types.{
  type BattleActorMessage, type BattleActorState, type BattleType,
  type CustomWebsocketMessage, AddUpdate, Ambush, BattleActorState, BattleEnded,
  Cemetary, Demon, End, EnemyActionStarted, EnemyDied, EnemyGotHit, EnemyHit,
  EnemyTribe, MakeActions, PlayerActionStarted, PlayerDied, PlayerGotHit,
  PlayerHit, Ravine, ResetEnemyHit, ResetHit, SetupBattle, SetupEnemy,
  ShutdownEnemy, Start, YourEnemyDied,
}

import app/actors/enemy
import birl
import gleam/dynamic.{type Dynamic}
import gleam/erlang/process.{type Subject}
import gleam/float
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/otp/actor.{type Next}
import gleam/string

/// Creates the Actor
///
pub fn start(
  battle_type: BattleType,
  game_subject: Subject(Subject(BattleActorMessage)),
  player_subject: Subject(CustomWebsocketMessage),
) -> Result(process.Pid, Dynamic) {
  actor.start_spec(actor.Spec(
    init: fn() {
      let battle_subject = process.new_subject()
      process.send(game_subject, battle_subject)

      let selector =
        process.new_selector()
        |> process.selecting(battle_subject, function.identity)

      actor.Ready(
        BattleActorState(
          0,
          None,
          battle_type,
          battle_subject,
          player_subject,
          None,
          [],
          [],
        ),
        selector,
      )
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
  io.debug("Battle Actor" <> int.to_string(state.id) <> " got the message")
  io.debug(message_for_actor)
  case message_for_actor {
    SetupBattle(id, game) -> {
      let enemy_subject = case state.battle_type {
        Ravine(w_type) | EnemyTribe(w_type) | Ambush(w_type) -> {
          let enemy_subject = enemy.start(w_type, state.myself)
          process.send(enemy_subject, SetupEnemy(enemy_subject))
          //start the enemy making actions (rolling dice, hitting, etc.)
          process.send(enemy_subject, MakeActions)
          Some(enemy_subject)
        }
        Demon | Cemetary -> {
          //predefined warrior types
          //should be DemonicSpirit and Ghost / Zombie (randomize between the two)
          //TODO - for now - swordsman
          let enemy_subject = enemy.start("", state.myself)
          process.send(enemy_subject, SetupEnemy(enemy_subject))
          //start the enemy making actions (rolling dice, hitting, etc.)
          process.send(enemy_subject, MakeActions)
          Some(enemy_subject)
        }
        _ -> {
          //its fog - TODO - battle other player
          None
        }
      }
      BattleActorState(..state, id: id, game: Some(game), enemy: enemy_subject)
      |> actor.continue
    }
    EnemyHit(action, strength) -> {
      let remove_health = calculate_remove_health(action, strength)
      process.send(state.player_subject, PlayerGotHit(remove_health))

      let enemy_action = End(birl.now())
      //could be start or end of hit
      let player_action = state.player_timestamps |> list.first()
      case player_action {
        Ok(Start(_time)) -> {
          //interrupt - player's action back to 0
          process.send(state.player_subject, ResetHit)
          process.send(
            state.player_subject,
            AddUpdate(
              "Your enemy hit you while you were making your move!\nYou must now restart your move",
            ),
          )
        }
        // if action is an end (or there isn't one), then nothing - can hit
        _ -> Nil
      }

      BattleActorState(
        ..state,
        enemy_timestamps: state.enemy_timestamps |> list.append([enemy_action]),
      )
      |> actor.continue
    }
    PlayerHit(action, strength) -> {
      let assert Some(enemy_subject) = state.enemy
      let remove_health = calculate_remove_health(action, strength)
      process.send(enemy_subject, EnemyGotHit(remove_health))

      let player_action = End(birl.now())
      //could be start or end of hit
      let enemy_action = state.enemy_timestamps |> list.first()
      case enemy_action {
        Ok(Start(_time)) -> {
          //interrupt - enemy's action back to 0
          process.send(enemy_subject, ResetEnemyHit)
        }
        _ -> Nil
      }
      process.send(
        state.player_subject,
        AddUpdate(
          "You hit the enemy; they lost "
          <> int.to_string(remove_health)
          <> " hearts",
        ),
      )
      BattleActorState(
        ..state,
        player_timestamps: state.player_timestamps
          |> list.append([player_action]),
      )
      |> actor.continue
    }
    EnemyDied -> {
      let assert Some(game) = state.game
      process.send(state.player_subject, YourEnemyDied)
      process.send(game, BattleEnded(state.id))
      actor.Stop(process.Normal)
    }
    PlayerDied -> {
      let assert Some(enemy_subject) = state.enemy
      let assert Some(game) = state.game
      process.send(enemy_subject, ShutdownEnemy)
      process.send(game, BattleEnded(state.id))
      actor.Stop(process.Normal)
    }
    PlayerActionStarted ->
      BattleActorState(
        ..state,
        player_timestamps: state.player_timestamps
          |> list.append([Start(birl.now())]),
      )
      |> actor.continue
    EnemyActionStarted ->
      BattleActorState(
        ..state,
        enemy_timestamps: state.enemy_timestamps
          |> list.append([Start(birl.now())]),
      )
      |> actor.continue
  }
}

/// Calculates the amount of health to remove from a party in a battle, when they get hit
///
fn calculate_remove_health(action: #(Int, Int, Int), strength: Int) {
  let multiplier_1 = multipliers(action.0)
  let multiplier_2 = multipliers(action.1)
  let multiplier_3 = multipliers(action.2)
  let multiplier_4 = multipliers(strength)
  let assert Ok(remove_health) =
    1.0 *. multiplier_1 *. multiplier_2 *. multiplier_3 *. multiplier_4
    |> float.floor
    |> float.to_string
    |> string.drop_end(2)
    |> int.parse
  remove_health
}

/// The multiplier for action values in a Hit
///
/// (may be swapped out for different multipliers for different values in future)
///
fn multipliers(num: Int) {
  case num {
    6 -> 1.5
    5 -> 1.4
    4 -> 1.3
    3 -> 1.2
    2 -> 1.1
    _ -> 1.0
  }
}
