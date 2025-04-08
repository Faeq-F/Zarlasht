import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddPlayer, AddedName, Battle, GameActorState, GameState, GetState,
  Home, JoinGame, Move, Player, PlayerMoved, PrepareGame, SendToClient,
  SetupBattle, SwapColors, UpdatePlayerState, UpdateState, UserDisconnected,
  Wait,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None}
import gleam/otp/actor.{type Next}
import gleam/otp/static_supervisor as sup
import logging.{Info}
import lustre/element

import app/actors/battle
import app/pages/created_game.{created_game_page, get_color, player_container}

pub fn user_disconnected(player: Player, state: GameActorState) {
  //let other players know - custom message (health retreated, scared, etc.)
  //remove from state
  GameActorState(..state, participants: {
    state.participants
    |> list.filter(fn(participant) { { participant.0 }.number != player.number })
  })
}
