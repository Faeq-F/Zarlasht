//// All Websocket related functions for the app

import app/actors/actor_types.{
  type DirectorActorMessage, type PlayerSocket, type WebsocketActorState, Chat,
  DequeueParticipant, Dice, Disconnect, GameActorState, GameState, GetState,
  GetStateWS, Home, JoinGame, Map, Player, PlayerSocket, SendToClient, StateWS,
  UpdatePlayerState, UpdateState, UserDisconnected, Wait, WebsocketActorState,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/http/request.{type Request, Request}
import gleam/int
import gleam/io
import gleam/option.{None, Some}
import gleam/otp/actor
import gleam/otp/supervisor
import gleam/string
import juno
import logging.{Alert, Info}
import lustre/attribute
import lustre/element
import lustre/element/html
import mist.{type Connection, Custom}

import app/lib/create_game.{on_create_game, update_colors}
import app/lib/game.{
  go_to_chats, go_to_dice_roll, go_to_home, go_to_map, start_game, switch_chat,
  update_chat_messages,
}
import app/lib/join_game.{on_join_game, on_to_join_game}
import app/lib/set_name.{set_name}
import app/pages/chat.{chat, chat_section}

import app/pages/set_name as sn_pg

//TODO
//swap out io.debug with logs

///See [here](https://hexdocs.pm/mist/mist.html#websocket)
///
pub fn new(req: Request(Connection), director: Subject(DirectorActorMessage)) {
  mist.websocket(
    request: req,
    on_init: fn(_conn) {
      let ws_subject = process.new_subject()
      let new_selector =
        process.new_selector()
        |> process.selecting(ws_subject, function.identity)
      logging.log(Info, "A Websocket Connected")
      // Set state for the connection with empty defaults
      #(
        WebsocketActorState(
          game_code: 0,
          player: Player(0, "", "", 10, 1, #(1, 21), []),
          ws_subject: ws_subject,
          game_subject: None,
          director_subject: director,
        ),
        Some(new_selector),
      )
    },
    on_close: fn(state) {
      logging.log(Info, "A Websocket Disconnected")
      case state.game_subject {
        Some(game_subject) -> {
          process.send(game_subject, UserDisconnected(state.player))
          //may have been connected to a waiting game
          process.send(
            state.director_subject,
            DequeueParticipant(state.player, state.game_code),
          )
          io.debug("Removed player from the game")
        }
        _ -> {
          io.debug("Socket was not part of a game")
        }
      }
      Nil
    },
    handler: handle_ws_message,
  )
}

///Handle all messages from the client and from other Actors
///
fn handle_ws_message(state, conn, message) {
  case message {
    mist.Custom(SendToClient(_)) -> {
      logging.log(Info, "Websocket message recieved ~ page update")
    }
    _ -> {
      logging.log(
        Info,
        "Websocket message recieved ~\n" <> message |> string.inspect,
      )
    }
  }
  case message {
    mist.Text("ping") -> {
      let assert Ok(_) = mist.send_text_frame(conn, "pong")
      actor.continue(state)
    }

    mist.Text(message) -> {
      let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
      let assert Ok(juno.Object(headers_dict)) =
        message_dict |> dict.get("HEADERS")
      let assert Ok(juno.String(trigger)) =
        headers_dict |> dict.get("HX-Trigger")

      case trigger {
        "create" -> on_create_game(PlayerSocket(conn, state)) |> actor.continue

        "set-name-form" ->
          set_name(message, PlayerSocket(conn, state))
          |> actor.continue

        "join" -> on_to_join_game(PlayerSocket(conn, state)) |> actor.continue

        "join-game-form" ->
          on_join_game(message, PlayerSocket(conn, state))
          |> actor.continue

        "colors" ->
          update_colors(message, PlayerSocket(conn, state))
          |> actor.continue

        "start_game" -> start_game(PlayerSocket(conn, state)) |> actor.continue

        "go_to_home" -> go_to_home(state, conn) |> actor.continue

        "go_to_chats" -> go_to_chats(state, conn) |> actor.continue

        "chat_messages" -> {
          update_chat_messages(state, conn)
          state |> actor.continue
        }

        "go_to_map" | "map" -> go_to_map(state, conn) |> actor.continue

        "go_to_dice_roll" -> go_to_dice_roll(state, conn) |> actor.continue

        "switch_chat_" <> player_to_chat_to ->
          switch_chat(player_to_chat_to, state, conn) |> actor.continue

        "send_message_" <> player_to_send_to ->
          game.send_message(
            player_to_send_to,
            message,
            PlayerSocket(conn, state),
          )
          |> actor.continue

        _ -> {
          logging.log(Alert, "Unknown Trigger")
          actor.continue(state)
        }
      }
    }

    mist.Custom(JoinGame(game_subject)) -> {
      let new_state =
        WebsocketActorState(..state, game_subject: Some(game_subject))
      let assert Ok(_) = mist.send_text_frame(conn, sn_pg.set_name_page())
      new_state |> actor.continue
    }

    mist.Custom(UpdatePlayerState(player_state)) -> {
      actor.continue(WebsocketActorState(..state, player: player_state))
    }

    mist.Custom(GetStateWS(asker)) -> {
      process.send(asker, StateWS(state))
      state |> actor.continue
    }

    mist.Custom(SendToClient(text)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, text)
      actor.continue(state)
    }

    mist.Custom(Disconnect) -> {
      // The forced reload will disconnect the socket
      let assert Ok(_) = mist.send_text_frame(conn, disconnect())
      state |> actor.continue
    }

    mist.Binary(binary) -> {
      logging.log(logging.Notice, "Discarding unexpected binary; received ~")
      io.debug(binary)
      actor.continue(state)
    }

    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)

    _ -> {
      logging.log(Alert, "Unknown Message")
      actor.continue(state)
    }
  }
}

///The JS script to alert the player that the opponent has disconnected, and to disconnect them
///
fn disconnect() {
  html.div([attribute.id("page")], [
    html.script(
      [],
      "alert('Your opponent disconnected!'); window.onbeforeunload = null; location.reload();",
    ),
  ])
  |> element.to_string
}
