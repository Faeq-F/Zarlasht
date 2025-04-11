//// The handler for preparing a game to start

import app/actors/actor_types.{type GameActorState, GameActorState, Home}
import gleam/dict
import gleam/list

/// The handler for the PrepareGame message
///
pub fn prepare_game(state: GameActorState) {
  //setup chats
  let setup_player_chats =
    state.participants
    |> list.combination_pairs()
    |> list.fold(dict.new(), fn(dict, pair) {
      dict
      |> dict.insert(#({ pair.0.0 }.number, { pair.1.0 }.number), [])
    })
  //no one has an ally yet
  let setup_ally_chats =
    state.participants
    |> list.fold(dict.new(), fn(dict, player) {
      dict
      |> dict.insert([{ player.0 }.number], [])
    })

  //setup page state
  let setup_pages =
    state.participants
    |> list.fold(dict.new(), fn(dict, player) {
      dict
      |> dict.insert({ player.0 }.number, Home)
    })

  GameActorState(
    ..state,
    player_chats: setup_player_chats,
    ally_chats: setup_ally_chats,
    pages_in_view: setup_pages,
  )
}
