/// The handler for rolling dice when in battle
import app/actors/actor_types.{
  type BattleType, type WebsocketActorState, Battle, HitEnemy, Player,
  PlayerStartedHit, WebsocketActorState,
}

import gleam/erlang/process
import gleam/int
import gleam/list
import gleam/option.{Some}
import lustre/element
import mist

import app/pages/roll_die.{
  anim_get_next_dice, dice_result, roll_section, rolled_die,
}

/// The handler for rolling dice when in battle
///
pub fn roll_battle(
  btype: BattleType,
  a_type: Int,
  damage: Int,
  defence: Int,
  state: WebsocketActorState,
  conn: mist.WebsocketConnection,
) {
  let assert Some(game) = state.game_subject
  // TODO - battle features
  // TODO - let game/battle know
  case a_type == 0 || damage == 0 || defence == 0 {
    True -> {
      //animate dice by sending it multiple times
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      |> list.each(fn(_x) {
        let assert Ok(_) = mist.send_text_frame(conn, anim_get_next_dice())
        process.sleep(100)
      })
      let roll = case int.random(6) {
        //upper is exclusive, 0 is inclusive
        0 -> 6
        number -> number
      }
      let assert Ok(_) =
        mist.send_text_frame(conn, rolled_die(roll) |> element.to_string)

      let action = case a_type, damage, defence {
        0, _, _ -> {
          process.send(game, PlayerStartedHit(state.player.number))
          Battle(btype, roll, damage, defence)
        }
        _, 0, _ -> Battle(btype, a_type, roll, defence)
        x, y, _ if x < 4 && y < 4 -> Battle(btype, a_type, roll + y, defence)
        _, _, _ -> Battle(btype, a_type, damage, roll)
      }

      let assert Ok(_) =
        mist.send_text_frame(conn, roll_section(action) |> element.to_string)
      let assert Ok(_) =
        mist.send_text_frame(conn, dice_result(action) |> element.to_string)
      WebsocketActorState(
        ..state,
        player: Player(..state.player, action: action),
      )
    }
    _ -> {
      //Hit
      let assert Battle(b_type, a_type, a_damage, ds) = state.player.action
      process.send(
        game,
        HitEnemy(
          state.player.number,
          #(a_type, a_damage, ds),
          state.player.strength,
        ),
      )
      WebsocketActorState(
        ..state,
        player: Player(..state.player, action: Battle(b_type, 0, 0, 0)),
      )
    }
  }
}
