//// The handler for adding a player to a game

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, GameActorState, Player, SendToClient, UpdatePlayerState,
}

import app/pages/created_game.{get_color, player_container}
import gleam/erlang/process.{type Subject}
import gleam/list
import lustre/element

/// The handler for the AddPlayer message
///
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
