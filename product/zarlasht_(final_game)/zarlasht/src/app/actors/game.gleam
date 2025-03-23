//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddPlayer, AddedName, Disconnect, GameActorState, GameState,
  GetState, Home, JoinGame, Player, PrepareGame, SendToClient, SwapColors,
  UpdatePlayerState, UpdateState, UserDisconnected, Wait,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}
import lustre/element

import app/pages/created_game.{created_game_page, get_color, player_container}

/// Creates the actor
///
pub fn start(code: Int) -> Subject(GameActorMessage) {
  let state =
    GameActorState(
      code: code,
      participants: [],
      colors: [
        // available colors for players to be
        "orange", "amber", "yellow", "lime", "emerald", "teal", "sky", "blue",
        "violet", "purple", "pink", "rose",
      ],
      used_colors: [
        // default colors - minimum 5 players for the game
        "red", "fuchsia", "indigo", "cyan", "green",
      ],
      player_chats: dict.new(),
      ally_chats: dict.new(),
      pages_in_view: dict.new(),
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
    AddPlayer(player, game_subject) -> {
      let new_player = #(
        Player(
          ..player.0,
          color: get_color({ player.0 }.number, state, game_subject),
        ),
        player.1,
      )

      process.send(player.1, UpdatePlayerState(new_player.0))

      let new_state =
        GameActorState(
          ..state,
          participants: state.participants |> list.append([new_player]),
        )

      list.each(state.participants, fn(participant) {
        //send them an update with players
        process.send(
          participant.1,
          SendToClient(
            player_container(new_state, game_subject) |> element.to_string,
          ),
        )
      })

      new_state |> actor.continue
    }
    AddedName(player, game_subject, name) -> {
      let participants =
        list.map(state.participants, fn(participant) {
          case { participant.0 }.number == player.number {
            True -> #(Player(..player, name: name), participant.1)
            _ -> participant
          }
        })
      let new_state = GameActorState(..state, participants: participants)
      list.each(participants, fn(participant) {
        case { participant.0 }.number == player.number {
          True -> {
            //send them the entire page - they are the new player
            process.send(
              participant.1,
              SendToClient(created_game_page(new_state, game_subject)),
            )
          }
          _ -> {
            //send them an update with players
            process.send(
              participant.1,
              SendToClient(
                player_container(new_state, game_subject) |> element.to_string,
              ),
            )
          }
        }
      })
      new_state |> actor.continue
    }
    UserDisconnected(player) -> {
      //let other players know - custom message (health retreated, scared, etc.)
      //remove from state
      GameActorState(..state, participants: {
        state.participants
        |> list.filter(fn(participant) {
          { participant.0 }.number != player.number
        })
      })
      |> actor.continue
    }
    SwapColors(colors, game_subject) -> {
      let indexed_colors =
        colors
        |> list.index_map(fn(color, i) { #(i, color) })

      //map participants to new participants with updated colors & update players' state
      let new_participants =
        state.participants
        |> list.map(fn(participant) {
          let assert Ok(color) =
            indexed_colors
            |> list.find(fn(color) { color.0 == { participant.0 }.number - 1 })
          let new_player = Player(..participant.0, color: color.1)
          process.send(participant.1, UpdatePlayerState(new_player))
          #(new_player, participant.1)
        })

      let new_state =
        GameActorState(
          ..state,
          participants: new_participants,
          used_colors: colors,
        )
      //send a message to every partcipant, updating the page
      list.each(new_state.participants, fn(participant) {
        process.send(
          participant.1,
          SendToClient(
            player_container(new_state, game_subject) |> element.to_string,
          ),
        )
      })

      new_state |> actor.continue
    }
    PrepareGame -> {
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
      |> actor.continue
    }
    UpdateState(new_state) -> {
      new_state |> actor.continue
    }
    GetState(asker) -> {
      process.send(asker, GameState(state))
      state |> actor.continue
    }
  }
}
