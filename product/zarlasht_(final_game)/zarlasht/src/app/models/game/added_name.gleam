//// The handler for a player setting their name

import app/actors/actor_types.{
  type GameActorMessage, type GameActorState, type Player, GameActorState,
  Player, SendToClient,
}

import gleam/erlang/process.{type Subject}
import gleam/list
import lustre/element

import app/pages/created_game.{created_game_page,  player_container}


/// The handler for the AddedName message
///
pub fn added_name(
  player: Player,
  game_subject: Subject(GameActorMessage),
  name: String,
  state: GameActorState,
) {
  let participants =
    list.map(state.participants, fn(participant) {
      case { participant.0 }.number == player.number {
        True -> #(Player(..player, name: name), participant.1)
        _ -> participant
      }
    })
  let new_state = GameActorState(..state, participants: participants)
  list.each(participants, fn(participant) {
    case { participant.0 }.number == player.number {
      True -> {
        //send them the entire page - they are the new player
        process.send(
          participant.1,
          SendToClient(created_game_page(new_state, game_subject)),
        )
      }
      _ -> {
        //send them an update with players
        process.send(
          participant.1,
          SendToClient(
            player_container(new_state, game_subject) |> element.to_string,
          ),
        )
      }
    }
  })
  new_state
}
