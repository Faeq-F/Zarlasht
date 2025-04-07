import app/actors/actor_types.{
  type BattleType, type DirectorActorMessage, type PlayerSocket,
  type WebsocketActorState, Ambush, Battle, Cemetary, Chat, Demon,
  DequeueParticipant, Dice, Disconnect, EnemyTribe, GameActorState, GameState,
  GetState, GetStateWS, Home, JoinGame, Map, Move, Player, PlayerMoved,
  PlayerSocket, Ravine, SendToClient, StateWS, UpdatePlayerState, UpdateState,
  UserDisconnected, Wait, WebsocketActorState,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/http/request.{type Request, Request}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/otp/actor
import gleam/otp/supervisor
import gleam/otp/task
import gleam/string
import juno
import logging.{Alert, Info}
import lustre/attribute
import lustre/element
import lustre/element/html
import mist.{type Connection, Custom}

import app/models/websocket/messaging.{
  send_message, switch_chat, update_chat_messages,
}
import app/models/websocket/switch_pages.{
  go_to_chats, go_to_dice_roll, go_to_home, go_to_map,
}

import app/pages/chat.{chat, chat_section}
import app/pages/map.{map_grid}
import app/pages/roll_die.{
  already_rolled, anim_get_next_dice, dice_result, roll_section, rolled_die,
}
import app/pages/set_name as sn_pg

pub fn roll_battle(
  btype: BattleType,
  a_type: Int,
  damage: Int,
  defence: Int,
  state: WebsocketActorState,
  conn: mist.WebsocketConnection,
) {
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
        0, _, _ -> Battle(btype, roll, damage, defence)
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
      let assert Ok(_) = mist.send_text_frame(conn, already_rolled())
      state
    }
  }
}
