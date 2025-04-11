//// The handler for rolling dice when not in battle

import app/actors/actor_types.{
  type WebsocketActorState, Move, Player, WebsocketActorState,
}
import gleam/erlang/process
import gleam/int
import gleam/list
import lustre/element
import mist

import app/pages/roll_die.{
  already_rolled, anim_get_next_dice, dice_result, roll_section, rolled_die,
}

/// The handler for rolling dice when not in battle (moving through the map)
///
pub fn roll_move(
  to_move_by: Int,
  state: WebsocketActorState,
  conn: mist.WebsocketConnection,
) {
  case to_move_by {
    0 -> {
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
      let action = Move(roll)
      //update to page info
      let assert Ok(_) =
        mist.send_text_frame(conn, roll_section(action) |> element.to_string)
      let assert Ok(_) =
        mist.send_text_frame(conn, dice_result(action) |> element.to_string)
      //update state
      WebsocketActorState(
        ..state,
        player: Player(..state.player, action: action),
      )
    }
    _ -> {
      let assert Ok(_) = mist.send_text_frame(conn, already_rolled())
      state
    }
  }
}
