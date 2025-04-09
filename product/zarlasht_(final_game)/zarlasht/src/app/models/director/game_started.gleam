//// The handler for a GameStarted message to the director actor

import app/actors/actor_types.{
  type DirectorActorState, DirectorActorState, PrepareGame, SendToClient,
}

import app/pages/game as game_page
import carpenter/table
import gleam/dict.{drop, get}
import gleam/erlang/process
import gleam/list

/// The handler for the GameStarted message
///
pub fn game_started(game_code: Int, state: DirectorActorState) {
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
}
