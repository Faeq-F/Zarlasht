//// All Websocket related functions for the app

import app/actors/actor_types.{
  type DirectorActorMessage, type PlayerSocket, type WebsocketActorState, Battle,
  Chat, DequeueParticipant, Dice, Disconnect, GameActorState, GameState,
  GetState, GetStateWS, Home, JoinGame, Map, Move, Player, PlayerMoved,
  PlayerSocket, SendToClient, StateWS, UpdatePlayerState, UpdateState,
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

import app/lib/create_game.{on_create_game, update_colors}
import app/lib/game.{
  go_to_chats, go_to_dice_roll, go_to_home, go_to_map, start_game, switch_chat,
  update_chat_messages,
}
import app/lib/join_game.{on_join_game, on_to_join_game}
import app/lib/set_name.{set_name}
import app/pages/chat.{chat, chat_section}
import app/pages/map.{map_grid}
import app/pages/roll_die.{
  already_rolled, anim_get_next_dice, dice_result, rolled_die,
}
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
          player: Player(0, "", "", 10, 1, #(1, 21), [], Move(0)),
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

        "clickable_position_" <> position -> {
          let assert Some(game_subject) = state.game_subject
          //parse position
          let assert Ok(x) = position |> string.split("_") |> list.first()
          let assert Ok(y) = position |> string.split("_") |> list.last()
          let assert Ok(x) = int.parse(x)
          let assert Ok(y) = int.parse(y)
          //check if we should enter battle
          let assert Ok(Some(action)) =
            list.index_map(map_grid(), fn(z, row) {
              list.index_map(z, fn(cell, column) {
                case column == x && row == y {
                  True -> {
                    //randomize battle based off cell type
                    Some(case cell {
                      // 4 = red = enemy tribe - always battle (warrior)
                      4 -> Battle(0, 0, 0)
                      // 5 = cyan = cemetary - 30% chance (undead)
                      5 ->
                        case int.random(10) {
                          num if num < 3 -> Battle(0, 0, 0)
                          _ -> Move(0)
                        }
                      // 6 = teal = ritual - always battle (demon)
                      6 -> Battle(0, 0, 0)
                      // 7 = violet = ravine - 70%
                      7 ->
                        case int.random(10) {
                          num if num < 7 -> Battle(0, 0, 0)
                          _ -> Move(0)
                        }
                      // 8 = lime = fog - depends on who nearby - TODO
                      8 -> Move(0)
                      // 9 = sky = ambush - always battle
                      9 -> Battle(0, 0, 0)
                      // 0 = white = mountain - no battle (can't be here)
                      // 1 = amber = path - no battle
                      // 2 = emerald = beginning - no battle
                      // 3 = pink = end - no battle
                      _ -> Move(0)
                    })
                  }
                  _ -> None
                }
              })
            })
            |> list.flatten
            |> list.find(fn(el) {
              el == Some(Move(0)) || el == Some(Battle(0, 0, 0))
            })
          //update game state
          let player =
            Player(
              ..state.player,
              action: action,
              position: #(x, y),
              old_positions: state.player.old_positions
                |> list.append([state.player.position]),
            )
          process.send(game_subject, PlayerMoved(player, game_subject))
          //update overall state, including move action
          WebsocketActorState(..state, player: player)
          |> actor.continue
        }

        "go_to_dice_roll" -> go_to_dice_roll(state, conn) |> actor.continue

        "roll" -> {
          //TODO - refactor
          case state.player.action {
            Move(to_move_by) -> {
              case to_move_by {
                0 -> {
                  let assert Ok(_) =
                    mist.send_text_frame(conn, anim_get_next_dice())
                  //after some time send normal die
                  //task.await_forever(task.async(fn() { process.sleep(4000) }))
                  let roll = case int.random(6) {
                    //upper is exclusive, 0 is inclusive
                    0 -> 6
                    number -> number
                  }
                  let assert Ok(_) =
                    mist.send_text_frame(
                      conn,
                      rolled_die(roll) |> element.to_string,
                    )
                  let action = Move(roll)
                  //update to page info
                  let assert Ok(_) =
                    mist.send_text_frame(
                      conn,
                      dice_result(action) |> element.to_string,
                    )
                  //update state
                  WebsocketActorState(
                    ..state,
                    player: Player(..state.player, action: action),
                  )
                  |> actor.continue
                }
                _ -> {
                  let assert Ok(_) =
                    mist.send_text_frame(conn, already_rolled())
                  state |> actor.continue
                }
              }
            }
            Battle(a_type, damage, defence) -> {
              // TODO - battle features
              // TODO - let game/battle know
              //check if all 3 filled, then already_rolled
              case a_type == 0 || damage == 0 || defence == 0 {
                True -> {
                  //else fill the on not set & update state & page info
                  let assert Ok(_) =
                    mist.send_text_frame(conn, anim_get_next_dice())
                  let roll = case int.random(6) {
                    //upper is exclusive, 0 is inclusive
                    0 -> 6
                    number -> number
                  }
                  let assert Ok(_) =
                    mist.send_text_frame(
                      conn,
                      rolled_die(roll) |> element.to_string,
                    )

                  let action = case a_type, damage, defence {
                    0, _, _ -> Battle(roll, damage, defence)
                    _, 0, _ -> Battle(a_type, roll, defence)
                    _, _, _ -> Battle(a_type, damage, roll)
                  }

                  let assert Ok(_) =
                    mist.send_text_frame(
                      conn,
                      dice_result(action) |> element.to_string,
                    )

                  WebsocketActorState(
                    ..state,
                    player: Player(..state.player, action: action),
                  )
                  |> actor.continue
                }
                _ -> {
                  let assert Ok(_) =
                    mist.send_text_frame(conn, already_rolled())
                  state |> actor.continue
                }
              }
            }
          }
        }

        "dice_anim" -> {
          let assert Ok(_) = mist.send_text_frame(conn, anim_get_next_dice())
          state |> actor.continue
        }

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
