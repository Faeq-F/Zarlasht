//// All Websocket related functions for the app

import app/actors/actor_types.{
  type DirectorActorMessage, type PlayerSocket, type WebsocketActorState,
  JoinGame, PlayerSocket, SendToClient, UserDisconnected, WebsocketActorState,
}
import app/lib/create_game.{on_create_game}
import app/lib/game_actions.{close_leaderboard, show_leaderboard}
import app/lib/name_set.{set_name}
import app/pages/set_name.{set_name_page}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/http/request.{type Request, Request}
import gleam/io
import gleam/option.{None, Some}
import gleam/otp/actor
import juno
import logging.{Alert, Info}
import mist.{type Connection, Custom}

///See [here](https://hexdocs.pm/mist/mist.html#websocket)
///
pub fn new(req: Request(Connection), director: Subject(DirectorActorMessage)) {
  mist.websocket(
    request: req,
    on_init: fn(_conn) {
      // Create a new subject for the current websocket process
      // that other actors will be able to send messages to
      let ws_subject = process.new_subject()
      let new_selector =
        process.new_selector()
        |> process.selecting(ws_subject, function.identity)
      logging.log(Info, "A Websocket Connected")
      // Set state for the connection with empty defaults
      #(
        WebsocketActorState(
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
          process.send(game_subject, UserDisconnected)
          io.debug("A game ended")
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
  logging.log(Info, "Websocket message recieved ~")
  io.debug(message)
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
          set_name(message, PlayerSocket(conn, state)) |> actor.continue
        "trophy" ->
          show_leaderboard(PlayerSocket(conn, state)) |> actor.continue
        "Xleaderboard" ->
          close_leaderboard(PlayerSocket(conn, state)) |> actor.continue
        "Enter" -> {
          game_actions.on_enter(PlayerSocket(conn, state), message)
          state |> actor.continue
        }
        "Wkey" -> {
          game_actions.on_w(PlayerSocket(conn, state), message)
          state |> actor.continue
        }
        "Skey" -> {
          game_actions.on_s(PlayerSocket(conn, state), message)
          state |> actor.continue
        }
        "UpArrowKey" -> {
          game_actions.on_up(PlayerSocket(conn, state), message)
          state |> actor.continue
        }
        "DownArrowKey" -> {
          game_actions.on_down(PlayerSocket(conn, state), message)
          state |> actor.continue
        }
        _ -> {
          logging.log(Alert, "Unknown Trigger")
          actor.continue(state)
        }
      }
    }

    mist.Custom(JoinGame(game_subject)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, set_name_page())
      actor.continue(
        WebsocketActorState(..state, game_subject: Some(game_subject)),
      )
    }

    mist.Custom(SendToClient(text)) -> {
      let assert Ok(_) = mist.send_text_frame(conn, text)
      actor.continue(state)
    }

    mist.Binary(binary) -> {
      logging.log(logging.Notice, "Discarding unexpected binary; received ~")
      io.debug(binary)
      actor.continue(state)
    }

    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}
