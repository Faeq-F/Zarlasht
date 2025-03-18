//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddPlayer, AddedName, Color, Disconnect, GameActorState, GetColor,
  JoinGame, SendToClient, UpdateColors, UserDisconnected, Wait,
}
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}

import app/pages/created_game.{created_game_page}

/// Creates the actor
///
pub fn start(
  code: Int,
  participants: List(#(Player, Subject(CustomWebsocketMessage))),
) -> Subject(GameActorMessage) {
  let state =
    GameActorState(
      code: code,
      participants: participants,
      colors: [
        // available colors for players to be
        "bg-orange-500/20", "bg-amber-500/20", "bg-yellow-500/20",
        "bg-lime-500/20", "bg-emerald-500/20", "bg-teal-500/20", "bg-sky-500/20",
        "bg-blue-500/20", "bg-violet-500/20", "bg-purple-500/20",
        "bg-pink-500/20", "bg-rose-500/20",
      ],
      used_colors: [
        // default colors - minimum 5 players for the game
        "bg-red-500/20", "bg-fuchsia-500/20", "bg-indigo-500/20",
        "bg-cyan-500/20", "bg-green-500/20",
      ],
    )
  let assert Ok(actor) = actor.start(state, handle_message)
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
    AddPlayer(player) -> {
      //list.each(state.participants, fn(participant) {
      // send them an update with players
      //todo
      //})

      GameActorState(
        ..state,
        participants: state.participants |> list.append([player]),
      )
      |> actor.continue
    }
    AddedName(player, socket, name) -> {
      list.each(state.participants, fn(participant) {
        case { participant.0 }.number == player.number {
          True -> {
            //send them the entire page - they are the new player
            process.send(
              participant.1,
              SendToClient(created_game_page(state.code)),
            )
          }
          _ -> {
            // send them an update with players
            todo
          }
        }
      })
      //
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
    UpdateColors(colors) -> {
      let new_participants = state.participants
      //map participants to new participnats with updated colors
      //send a message to every partcipant, updating the page
      GameActorState(..state, participants: new_participants) |> actor.continue
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
fn get_color(player_num: Int, state: GameActorState) {
  case player_num < 6 {
    True -> {
      //use default colors
      let assert Ok(color_grabbed) =
        state.used_colors
        |> list.index_map(fn(color, i) { #(i, color) })
        |> list.find(fn(color) { color.0 == player_num - 1 })
      #(color_grabbed, state)
    }
    False -> {
      //check if need to reuse colors
      let colors = case state.colors |> list.is_empty {
        True -> state.used_colors
        _ -> state.colors
      }
      let used_colors = case state.colors |> list.is_empty {
        True -> []
        _ -> state.used_colors
      }
      //get color
      let assert Ok(color_grabbed) = colors |> list.shuffle() |> list.first()
      //update color lists
      let colors = colors |> list.filter(fn(color) { color != color_grabbed })
      let used_colors = used_colors |> list.append(color_grabbed)
      //update state
      #(
        color_grabbed,
        GameActorState(..state, colors: colors, used_colors: used_colors),
      )
    }
  }
}
