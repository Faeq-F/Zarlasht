import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddPlayer, AddedName, Battle, GameActorState, GameState, GetState,
  Home, JoinGame, Move, Player, PlayerMoved, PrepareGame, SendToClient,
  SetupBattle, SwapColors, UpdatePlayerState, UpdateState, UserDisconnected,
  Wait,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None}
import gleam/otp/actor.{type Next}
import gleam/otp/static_supervisor as sup
import logging.{Info}
import lustre/element

import app/actors/battle
import app/pages/created_game.{created_game_page, get_color, player_container}

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
