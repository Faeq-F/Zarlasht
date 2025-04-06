import app/actors/actor_types.{
  type CustomWebsocketMessage, type DirectorActorMessage,
  type DirectorActorState, type Player, AddPlayer, DequeueParticipant,
  DirectorActorState, EnqueueParticipant, GameStarted, GetParticipants, JoinGame,
  Participants, PrepareGame, SendToClient, UpdateParticipant,
}
import gleam/function

import app/actors/game
import app/pages/game as game_page
import carpenter/table
import gleam/dict.{drop, get, insert}
import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor.{type Next}

pub fn enqueue_participant(
  game_code: Int,
  player: Player,
  participant_subject: Subject(CustomWebsocketMessage),
  state: DirectorActorState,
) {
  let participant = #(player, participant_subject)

  let new_queue = case state.games_waiting |> get(game_code) {
    Ok(game) -> {
      //They are joining a Game
      process.send(game.0, AddPlayer(participant, game.0))
      process.send(participant_subject, JoinGame(game_subject: game.0))
      state.games_waiting
      |> insert(game_code, #(game.0, [participant, ..game.1]))
    }
    _ -> {
      //They created the game
      let game_subject = game.start(game_code)
      process.send(game_subject, AddPlayer(participant, game_subject))
      process.send(participant_subject, JoinGame(game_subject: game_subject))
      state.games_waiting
      |> insert(game_code, #(game_subject, [participant]))
    }
  }

  DirectorActorState(games_waiting: new_queue)
}

pub fn dequeue_participant(
  player: Player,
  game_code: Int,
  state: DirectorActorState,
) {
  let assert Ok(game) = state.games_waiting |> get(game_code)
  case game.1 |> list.length() == 1 {
    True -> {
      //remove from ETS table
      let assert Ok(waiting_games) = table.ref("waiting_games")
      waiting_games |> table.delete(game_code)
      //remove from director state
      DirectorActorState(state.games_waiting |> drop([game_code]))
    }
    _ -> {
      //remove from director state
      state.games_waiting
      |> insert(game_code, #(
        game.0,
        game.1
          |> list.filter(fn(participant) {
            { participant.0 }.number != player.number
          }),
      ))
      |> DirectorActorState
    }
  }
}

pub fn update_participant(
  player: Player,
  game_code: Int,
  state: DirectorActorState,
) {
  let assert Ok(game) = state.games_waiting |> get(game_code)
  state.games_waiting
  |> insert(game_code, #(
    game.0,
    game.1
      |> list.map(fn(participant) {
        case { participant.0 }.number != player.number {
          True -> participant
          _ -> #(player, participant.1)
        }
      }),
  ))
  |> DirectorActorState
}
