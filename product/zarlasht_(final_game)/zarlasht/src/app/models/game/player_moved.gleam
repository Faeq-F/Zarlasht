//// The handler for a player moving in a game

import app/actors/actor_types.{
  type GameActorMessage, type GameActorState, type Player, Battle,
  GameActorState, Move, Player, SetupBattle,
}

import app/actors/battle
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/list
import gleam/option.{None}
import gleam/otp/static_supervisor as sup

/// The handler for the PlayerMoved message
///
pub fn player_moved(
  player: Player,
  game: Subject(GameActorMessage),
  state: GameActorState,
) {
  //check if action is battle
  let new_battles = case player.action {
    Battle(btype, _, _, _) -> {
      let assert Ok(player_subject) =
        state.participants
        |> list.find(fn(p) { { p.0 }.number == player.number })
      // create battle
      let game_subject = process.new_subject()
      let battle_erl = fn() {
        battle.start(btype, game_subject, player_subject.1)
      }
      // get id
      let id = case list.last(state.battles) {
        Ok(b) -> b.0 + 1
        _ -> 0
      }

      // add to supervisor
      let _ =
        sup.new(sup.OneForOne)
        |> sup.add(sup.supervisor_child(
          "battle_is_" <> id |> int.to_string,
          battle_erl,
        ))
        |> sup.auto_shutdown(sup.AnySignificant)
        |> sup.start_link

      let assert Ok(battle_subject) = process.receive(game_subject, 1000)
      let new_battle = #(id, battle_subject, player.number, None)
      // setup battle
      process.send(battle_subject, SetupBattle(id, game))
      // add to state
      state.battles |> list.append([new_battle])
    }
    Move(_) -> state.battles
  }
  //state update
  let assert Ok(old_player) =
    state.participants
    |> list.find(fn(p) { { p.0 }.number == player.number })
  let new_participants =
    state.participants
    |> list.filter(fn(p) { { p.0 }.number != player.number })
    |> list.append([#(player, old_player.1)])
  GameActorState(..state, battles: new_battles, participants: new_participants)
}
