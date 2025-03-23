//// The director actor - process to manage all tasks the server carries out

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, AddPlayer,
  DequeueParticipant, DirectorActorState, EnqueueParticipant, GameStarted,
  GetParticipants, JoinGame, Participants, PrepareGame, SendToClient,
  UpdateParticipant,
}
import gleam/function

import app/actors/game
import app/pages/game as game_page
import carpenter/table
import gleam/dict.{drop, get, insert}
import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor.{type Next}

/// Creates the Actor
pub fn start(
  _input: Nil,
  main_subject: Subject(Subject(DirectorActorMessage)),
) -> Result(Subject(DirectorActorMessage), actor.StartError) {
  actor.start_spec(actor.Spec(
    init: fn() {
      let director_subject = process.new_subject()
      process.send(main_subject, director_subject)

      let selector =
        process.new_selector()
        |> process.selecting(director_subject, function.identity)

      actor.Ready(DirectorActorState(dict.new()), selector)
    },
    init_timeout: 1000,
    loop: handle_message,
  ))
}

/// Handles messages from other actors
///
fn handle_message(
  message: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message {
    EnqueueParticipant(game_code, player, participant_subject) -> {
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
          process.send(
            participant_subject,
            JoinGame(game_subject: game_subject),
          )
          state.games_waiting
          |> insert(game_code, #(game_subject, [participant]))
        }
      }

      DirectorActorState(games_waiting: new_queue) |> actor.continue
    }
    DequeueParticipant(player, game_code) -> {
      let assert Ok(game) = state.games_waiting |> get(game_code)
      case game.1 |> list.length() == 1 {
        True -> {
          //remove from ETS table
          let assert Ok(waiting_games) = table.ref("waiting_games")
          waiting_games |> table.delete(game_code)
          //remove from director state
          DirectorActorState(state.games_waiting |> drop([game_code]))
          |> actor.continue
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
          |> actor.continue
        }
      }
    }
    UpdateParticipant(player, game_code) -> {
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
      |> actor.continue
    }
    GameStarted(game_code) -> {
      let assert Ok(game) = state.games_waiting |> get(game_code)
      //prepare the game
      process.send(game.0, PrepareGame)
      //send everyone in the game to the game page
      game.1
      |> list.each(fn(player) {
        process.send(player.1, SendToClient(game_page.game(player.0)))
      })
      //remove from ETS table
      let assert Ok(waiting_games) = table.ref("waiting_games")
      waiting_games |> table.delete(game_code)
      //remove from director state
      DirectorActorState(state.games_waiting |> drop([game_code]))
      |> actor.continue
    }
    GetParticipants(asker, game_code) -> {
      let participants = case state.games_waiting |> get(game_code) {
        Ok(game) -> game.1
        _ -> []
      }
      process.send(asker, Participants(participants))
      state |> actor.continue
    }
  }
}
