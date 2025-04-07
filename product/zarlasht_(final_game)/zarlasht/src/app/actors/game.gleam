//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type GameActorMessage, type GameActorState, AddPlayer, AddedName,
  GameActorState, GameState, GetState, PlayerMoved, PrepareGame, SwapColors,
  UpdateState, UserDisconnected,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/io
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

///Handle all messages  from other Actors
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

    UserDisconnected(player) -> {
      user_disconnected(player, state)
      |> actor.continue
    }
    SwapColors(colors, game_subject) ->
      swap_colors(colors, game_subject, state) |> actor.continue

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
