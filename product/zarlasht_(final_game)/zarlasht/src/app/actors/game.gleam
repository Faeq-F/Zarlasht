//// The game actor - process to manage a single game being played

import app/actors/actor_types.{
  type GameActorMessage, type GameActorState, AddPlayer, AddedName, BattleEnded,
  GameActorState, GameState, GetState, HitEnemy, IDied, PlayerDied, PlayerHit,
  PlayerMoved, PrepareGame, SwapColors, UpdateState, UserDisconnected,
}

import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}

/// Creates the actor
///
pub fn start(code: Int) -> Subject(GameActorMessage) {
  // set initial state
  let state =
    GameActorState(
      code: code,
      participants: [],
      colors: [
        // available colors for players to be
        "orange", "amber", "yellow", "lime", "emerald", "teal", "sky", "blue",
        "violet", "purple", "pink", "rose",
      ],
      used_colors: [
        // default colors - minimum 5 players for the game
        "red", "fuchsia", "indigo", "cyan", "green",
      ],
      player_chats: dict.new(),
      ally_chats: dict.new(),
      pages_in_view: dict.new(),
      battles: [],
    )
  let assert Ok(actor) = actor.start(state, handle_message)
  actor
}

import app/models/game/add_player.{add_player}
import app/models/game/added_name.{added_name}
import app/models/game/player_moved.{player_moved}
import app/models/game/prepare_game.{prepare_game}
import app/models/game/swap_colors.{swap_colors}
import app/models/game/user_disconnected.{user_disconnected}

///Handle all messages from other actors
///
fn handle_message(
  message_for_actor: GameActorMessage,
  state: GameActorState,
) -> Next(GameActorMessage, GameActorState) {
  logging.log(Info, "A Game Actor got the message")
  io.debug(message_for_actor)
  case message_for_actor {
    PlayerMoved(player, game) ->
      player_moved(player, game, state) |> actor.continue

    AddPlayer(player, game_subject) ->
      add_player(player, game_subject, state) |> actor.continue

    AddedName(player, game_subject, name) ->
      added_name(player, game_subject, name, state) |> actor.continue

    UserDisconnected(player) ->
      user_disconnected(player, state)
      |> actor.continue

    SwapColors(colors, game_subject) ->
      swap_colors(colors, game_subject, state) |> actor.continue

    HitEnemy(player, battle, strength) -> {
      let assert Ok(battle_subject) =
        state.battles
        |> list.find(fn(battle) { battle.2 == player })
      process.send(battle_subject.1, PlayerHit(battle, strength))
      state |> actor.continue
    }

    BattleEnded(id) -> {
      let new_battles =
        state.battles |> list.filter(fn(battle) { battle.0 != id })
      GameActorState(..state, battles: new_battles)
      |> actor.continue
    }

    IDied(player_num) -> {
      let assert Ok(battle) =
        state.battles
        |> list.find(fn(battle) { battle.2 == player_num })
      process.send(battle.1, PlayerDied)
      let new_participants =
        state.participants
        |> list.filter(fn(p) { { p.0 }.number != player_num })
      GameActorState(..state, participants: new_participants) |> actor.continue
    }

    PrepareGame ->
      prepare_game(state)
      |> actor.continue

    UpdateState(new_state) -> {
      new_state |> actor.continue
    }
    GetState(asker) -> {
      process.send(asker, GameState(state))
      state |> actor.continue
    }
  }
}
