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

pub fn add_player(
  player: #(Player, Subject(CustomWebsocketMessage)),
  game_subject: Subject(GameActorMessage),
  state: GameActorState,
) {
  let new_player = #(
    Player(
      ..player.0,
      color: get_color({ player.0 }.number, state, game_subject),
    ),
    player.1,
  )

  process.send(player.1, UpdatePlayerState(new_player.0))

  let new_state =
    GameActorState(
      ..state,
      participants: state.participants |> list.append([new_player]),
    )

  list.each(state.participants, fn(participant) {
    //send them an update with players
    process.send(
      participant.1,
      SendToClient(
        player_container(new_state, game_subject) |> element.to_string,
      ),
    )
  })

  new_state
}
