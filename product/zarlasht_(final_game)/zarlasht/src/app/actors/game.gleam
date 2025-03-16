//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddedName, Color, Disconnect, GameActorState, GetColor, JoinGame,
  SendToClient, UserDisconnected, Wait,
}
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}

/// Creates the actor
///
pub fn start(
  participants: List(#(Player, Subject(CustomWebsocketMessage))),
) -> Subject(GameActorMessage) {
  let state =
    GameActorState(
      participants: participants,
      colors: [
        "bg-red-500/20", "bg-orange-500/20", "bg-amber-500/20",
        "bg-yellow-500/20", "bg-lime-500/20", "bg-green-500/20",
        "bg-emerald-500/20", "bg-teal-500/20", "bg-cyan-500/20", "bg-sky-500/20",
        "bg-blue-500/20", "bg-indigo-500/20", "bg-violet-500/20",
        "bg-purple-500/20", "bg-fuchsia-500/20", "bg-pink-500/20",
        "bg-rose-500/20",
      ],
      used_colors: [],
    )
  let assert Ok(actor) = actor.start(state, handle_message)

  //send everyone to the set_name page
  //(by sending a message that holds the game_actor)
  list.each(participants, fn(participant) {
    process.send(participant.1, JoinGame(game_subject: actor))
  })
  // - do this on every added player - this would be only one anyway - refactor

  actor
}

///Handle all messages  from other Actors
///
fn handle_message(
  message_for_actor: GameActorMessage,
  state: GameActorState,
) -> Next(GameActorMessage, GameActorState) {
  logging.log(Info, "A Game Actor got the message")
  io.debug(message_for_actor)
  case message_for_actor {
    AddedName(player, socket, name) -> {
      state |> actor.continue
    }
    UserDisconnected(player) -> {
      //make other player disconnect
      //   list.each(state.participants, fn(participant) {
      //     case participant.0 == player {
      //       True -> {
      //         // they have already disconnected so can't send them a message
      //         Nil
      //       }
      //       _ -> {
      //         process.send(participant.1, Disconnect)
      //         Nil
      //       }
      //     }
      //   })
      actor.Stop(process.Abnormal("A player disconnected from the game"))
    }
    GetColor(ws) -> {
      process.send(ws, Color(get_color(state)))
      state |> actor.continue
    }
  }
}

/// Designed to get tailwind background  colors (e.g., "bg-red-500/20") to help identify players in the game
///
/// Colors will be random. If there are more players than colors, colors will repeat
///
fn get_color(state: GameActorState) {
  case state.colors |> list.is_empty {
    True -> ""
    _ -> ""
  }
}
