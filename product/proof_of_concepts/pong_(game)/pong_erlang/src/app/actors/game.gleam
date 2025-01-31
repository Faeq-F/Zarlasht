//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  DownHit, EnterHit, GameActorState, JoinGame, LeaderboardInformation, SHit,
  SendToClient, SetNames, Start, UpHit, UserDisconnected, WHit,
}
import app/lib/game_actions
import app/pages/game
import carpenter/table
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/otp/actor.{type Next}
import logging.{Info}

/// Creates the actor
///
pub fn start(
  user: Subject(CustomWebsocketMessage),
  director: Subject(actor_types.DirectorActorMessage),
) -> Subject(GameActorMessage) {
  let state =
    GameActorState(
      director:,
      user: user,
      player1name: "",
      player2name: "",
      state: Start,
      player1score: 0,
      player2score: 0,
    )
  let assert Ok(actor) = actor.start(state, handle_message)
  //send them to the set_name page
  process.send(user, JoinGame(game_subject: actor))
  actor
}

///Handle all messages  from other Actors
///
fn handle_message(
  message: GameActorMessage,
  state: GameActorState,
) -> Next(GameActorMessage, GameActorState) {
  logging.log(Info, "A Game Actor got the message")
  io.debug(message)
  case message {
    EnterHit(message) -> game_actions.enter_hit(message, state)
    WHit(message) -> game_actions.w_hit(message, state)
    SHit(message) -> game_actions.s_hit(message, state)
    UpHit(message) -> game_actions.up_hit(message, state)
    DownHit(message) -> game_actions.down_hit(message, state)

    SetNames(player1name, player2name) -> {
      let new_state =
        GameActorState(
          ..state,
          player1name: player1name,
          player2name: player2name,
        )
      process.send(
        state.user,
        SendToClient(game.game_page(player1name, player2name)),
      )
      new_state |> actor.continue
    }

    UserDisconnected -> {
      io.debug("User disconnected from the game")
      //save names & scores to ETS table (as cache) and Valkey db (long-term storage)
      let assert Ok(leaderboard) = table.ref("leaderboard")
      //check keys as player1name <> player2name and player2name <> player1name -> want to avoid duplicates
      let key1 = state.player1name <> state.player2name
      let key2 = state.player2name <> state.player1name
      let val =
        LeaderboardInformation(
          player1name: state.player1name,
          player2name: state.player2name,
          player1score: state.player1score,
          player2score: state.player2score,
        )
      case leaderboard |> table.lookup(key1) {
        [] -> {
          //check other key
          case leaderboard |> table.lookup(key2) {
            [] -> {
              //save using first key
              leaderboard
              |> table.insert([#(key1, val)])
              process.send(state.director, actor_types.AddKey(key1))
            }
            _ -> {
              //override key
              leaderboard
              |> table.insert([#(key2, val)])
              process.send(state.director, actor_types.AddKey(key2))
            }
          }
        }
        _ -> {
          //override key
          leaderboard
          |> table.insert([#(key1, val)])
          process.send(state.director, actor_types.AddKey(key1))
        }
      }
      actor.Stop(process.Killed)
    }
  }
}
