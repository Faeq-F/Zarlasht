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
