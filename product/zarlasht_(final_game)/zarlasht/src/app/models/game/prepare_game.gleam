import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddPlayer, AddedName, Battle, Disconnect, GameActorState,
  GameState, GetState, Home, JoinGame, Move, Player, PlayerMoved, PrepareGame,
  SendToClient, SetupBattle, SwapColors, UpdatePlayerState, UpdateState,
  UserDisconnected, Wait,
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

pub fn prepare_game(state: GameActorState) {
  //setup chats
  let setup_player_chats =
    state.participants
    |> list.combination_pairs()
    |> list.fold(dict.new(), fn(dict, pair) {
      dict
      |> dict.insert(#({ pair.0.0 }.number, { pair.1.0 }.number), [])
    })
  //no one has an ally yet
  let setup_ally_chats =
    state.participants
    |> list.fold(dict.new(), fn(dict, player) {
      dict
      |> dict.insert([{ player.0 }.number], [])
    })

  //setup page state
  let setup_pages =
    state.participants
    |> list.fold(dict.new(), fn(dict, player) {
      dict
      |> dict.insert({ player.0 }.number, Home)
    })

  GameActorState(
    ..state,
    player_chats: setup_player_chats,
    ally_chats: setup_ally_chats,
    pages_in_view: setup_pages,
  )
}
