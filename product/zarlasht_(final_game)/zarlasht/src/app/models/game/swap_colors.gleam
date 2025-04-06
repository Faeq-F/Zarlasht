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

pub fn swap_colors(
  colors: List(String),
  game_subject: Subject(GameActorMessage),
  state: GameActorState,
) {
  let indexed_colors =
    colors
    |> list.index_map(fn(color, i) { #(i, color) })

  //map participants to new participants with updated colors & update players' state
  let new_participants =
    state.participants
    |> list.map(fn(participant) {
      let assert Ok(color) =
        indexed_colors
        |> list.find(fn(color) { color.0 == { participant.0 }.number - 1 })
      let new_player = Player(..participant.0, color: color.1)
      process.send(participant.1, UpdatePlayerState(new_player))
      #(new_player, participant.1)
    })

  let new_state =
    GameActorState(..state, participants: new_participants, used_colors: colors)
  //send a message to every partcipant, updating the page
  list.each(new_state.participants, fn(participant) {
    process.send(
      participant.1,
      SendToClient(
        player_container(new_state, game_subject) |> element.to_string,
      ),
    )
  })

  new_state
}
