//// The director actor - process to manage all tasks the server carries out

import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, AddKey, DirectorActorState,
  EnqueueUser, Leaderboard, SendToClient,
}
import app/actors/game
import app/pages/leaderboard.{leaderboard}
import carpenter/table
import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor.{type Next}
import gleam/set
import gleam/yielder.{from_list, map, to_list}

/// Creates the Actor
pub fn start() -> Subject(DirectorActorMessage) {
  //need to get keys from db & fill ETS table with info
  let assert Ok(actor) =
    actor.start(DirectorActorState(set.new()), handle_message)
  actor
}

/// Handles messages from other actors
///
fn handle_message(
  message: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message {
    EnqueueUser(participant_subject, director_subject) -> {
      game.start(participant_subject, director_subject)
      state |> actor.continue
    }
    Leaderboard(user) -> {
      let assert Ok(leaderboard_ets) = table.ref("leaderboard")
      //create list of infos by grabbing from ETS table
      let information_list =
        state.leaderboard_keys
        |> set.to_list
        |> from_list
        |> map(fn(key) {
          let assert Ok(info) =
            leaderboard_ets |> table.lookup(key) |> list.first
          info.1
        })
        |> to_list
      //send the client the leaderboard
      process.send(user, SendToClient(leaderboard(information_list)))
      state |> actor.continue
    }
    AddKey(key) -> {
      //save key in db aswell
      DirectorActorState(set.union(
        state.leaderboard_keys,
        set.new() |> set.insert(key),
      ))
      |> actor.continue
    }
  }
}
