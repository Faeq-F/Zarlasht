//// All Websocket related functions for the app

import app/actors/actor_types.{
  type DirectorActorMessage, type PlayerSocket, type WebsocketActorState,
  DequeueParticipant, Disconnect, GameState, GetState, JoinGame, Player,
  PlayerSocket, SendToClient, UpdatePlayerState, UserDisconnected, Wait,
  WebsocketActorState,
}
import gleam/dict
import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/http/request.{type Request, Request}
import gleam/int
import gleam/io
import gleam/option.{None, Some}
import gleam/otp/actor
import gleam/string
import juno
import logging.{Alert, Info}
import lustre/attribute
import lustre/element
import lustre/element/html
import mist.{type Connection, Custom}

import app/lib/create_game.{on_create_game, update_colors}
import app/lib/game.{start_game}
import app/lib/join_game.{on_join_game, on_to_join_game}
import app/lib/set_name.{set_name}
import app/pages/chat.{chat, chat_section}
import app/pages/game as game_page
import app/pages/map.{map}
import app/pages/roll_die.{roll_die}
import app/pages/set_name as sn_pg

//TODO
//swap out io.debug with logs

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
          game_code: 0,
          player: Player(0, "", "", 10, 1, #(1, 21), [#(1, 21)]),
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
          set_name(message, PlayerSocket(conn, state)) |> actor.continue

        "join" -> on_to_join_game(PlayerSocket(conn, state)) |> actor.continue
        "join-game-form" ->
          on_join_game(message, PlayerSocket(conn, state))
          |> actor.continue

        "colors" ->
          update_colors(message, PlayerSocket(conn, state)) |> actor.continue
        "start_game" ->
          start_game(PlayerSocket(conn, state))
          |> actor.continue

        "go_to_home" -> {
          let assert Ok(_) =
            mist.send_text_frame(conn, game_page.game(state.player))
          state |> actor.continue
        }
        "go_to_chats" -> {
          let assert Ok(_) =
            mist.send_text_frame(conn, chat(PlayerSocket(conn, state)))
          state |> actor.continue
        }
        "go_to_map" -> {
          let assert Ok(_) = mist.send_text_frame(conn, map(state.player))
          state |> actor.continue
        }
        "go_to_dice_roll" -> {
          let assert Ok(_) = mist.send_text_frame(conn, roll_die(state.player))
          state |> actor.continue
        }

        trigger -> {
          case trigger |> string.starts_with("switch_chat_") {
            True -> {
              let assert Ok(player_to_chat_to) =
                int.parse(trigger |> string.drop_start(12))

              let assert Some(game_subject) = state.game_subject
              let assert GameState(game_state) =
                process.call_forever(game_subject, GetState)

              let assert Ok(_) =
                mist.send_text_frame(
                  conn,
                  chat_section(
                    player_to_chat_to,
                    PlayerSocket(conn, state),
                    game_state,
                  )
                    |> element.to_string,
                )
              state |> actor.continue
            }
            _ -> {
              //TODO - refactor
              case trigger |> string.starts_with("send_message_") {
                True -> {
                  let assert Ok(player_to_send_to) =
                    int.parse(trigger |> string.drop_start(13))
                  // get messageText
                  // update game state (correct dict)
                  // update pages being viewed - poll?
                  todo
                }
                _ -> {
                  logging.log(Alert, "Unknown Trigger")
                  actor.continue(state)
                }
              }
            }
          }
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
