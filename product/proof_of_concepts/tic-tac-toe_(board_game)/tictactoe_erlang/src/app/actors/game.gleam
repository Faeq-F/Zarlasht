import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type GameState, type Player, AddedName, BoxClick, Disconnect, GameActorState,
  GameState, JoinGame, Message, Neither, O, ResetGame, SendToClient,
  UserDisconnected, Wait, X,
}
import app/lib/game_action.{new_game_state}
import app/pages/game.{game_page, message}
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}

pub fn start(
  participants: List(#(Player, Subject(CustomWebsocketMessage))),
) -> Subject(GameActorMessage) {
  let state =
    GameActorState(
      participants: participants,
      names_set: 0,
      player_one_name: "",
      player_two_name: "",
      game_state: GameState(turn: X, state: [
        // player markings in boxes - left to right, top to bottom
        Neither,
        Neither,
        Neither,
        Neither,
        Neither,
        Neither,
        Neither,
        Neither,
        Neither,
      ]),
    )
  let assert Ok(actor) = actor.start(state, handle_message)

  //send everyone to the set_name page
  //(by sending a message that holds the game_actor)
  list.each(participants, fn(participant) {
    process.send(participant.1, JoinGame(game_subject: actor))
  })

  actor
}

fn handle_message(
  message_for_actor: GameActorMessage,
  state: GameActorState,
) -> Next(GameActorMessage, GameActorState) {
  logging.log(Info, "A Game Actor got the message")
  io.debug(message_for_actor)
  case message_for_actor {
    BoxClick(player, box_index) -> {
      // Update state for boxes
      let new_state = new_game_state(state, player, box_index)
      // Update turn
      let current_turn = state.game_state.turn
      let next_turn = case current_turn {
        X -> O
        _ -> X
      }
      let new_state =
        GameActorState(
          ..new_state,
          game_state: GameState(..new_state.game_state, turn: next_turn),
        )
      // Get winner
      let winner = get_winning_player(new_state.game_state)
      //send everyone updates
      list.each(state.participants, fn(p) {
        //status text
        process.send(
          p.1,
          SendToClient(game.update_status(
            new_state.game_state.turn == p.0,
            p.0,
            winner,
          )),
        )
        // updated grid
        process.send(
          p.1,
          SendToClient(
            game.game_grid(new_state.game_state, p.0, case winner {
              "Neither" -> new_state.game_state.turn == p.0
              _ -> False
              // if someone has won,
              // the grid should no longer have clickable boxes
            }),
          ),
        )
      })
      new_state |> actor.continue
    }

    Message(message_text, from_player) -> {
      list.each(state.participants, fn(p) {
        case p.0 == from_player {
          True -> {
            process.send(p.1, SendToClient(message(message_text, True)))
          }
          _ -> {
            process.send(p.1, SendToClient(message(message_text, False)))
          }
        }
      })
      state |> actor.continue
    }

    AddedName(player, ws_subject, name) -> {
      let assert Ok(first_person) = list.first(state.participants)
      let new_state = case player {
        first if first == first_person.0 ->
          GameActorState(
            ..state,
            names_set: state.names_set + 1,
            player_two_name: name,
          )
        _ ->
          GameActorState(
            ..state,
            names_set: state.names_set + 1,
            player_one_name: name,
          )
      }
      case new_state.names_set {
        1 -> process.send(ws_subject, Wait)
        _ -> {
          list.each(state.participants, fn(p) {
            // send each participantto the game page
            process.send(p.1, SendToClient(game_page()))
            //update game grid
            process.send(
              p.1,
              SendToClient(game.game_grid(
                state.game_state,
                p.0,
                state.game_state.turn == p.0,
              )),
            )
            //update player names
            process.send(
              p.1,
              SendToClient(game.player(X, new_state.player_one_name)),
            )
            process.send(
              p.1,
              SendToClient(game.player(O, new_state.player_two_name)),
            )
            //update status
            process.send(
              p.1,
              SendToClient(game.update_status(
                state.game_state.turn == p.0,
                p.0,
                get_winning_player(state.game_state),
              )),
            )
          })
        }
      }
      new_state |> actor.continue
    }

    ResetGame -> {
      let new_state =
        GameActorState(
          ..state,
          game_state: GameState(
            ..state.game_state,
            state: [
              Neither,
              Neither,
              Neither,
              Neither,
              Neither,
              Neither,
              Neither,
              Neither,
              Neither,
            ],
          ),
        )
      list.each(state.participants, fn(p) {
        //update game grid
        process.send(
          p.1,
          SendToClient(game.game_grid(
            new_state.game_state,
            p.0,
            new_state.game_state.turn == p.0,
          )),
        )
        //update status
        process.send(
          p.1,
          SendToClient(game.update_status(
            new_state.game_state.turn == p.0,
            p.0,
            get_winning_player(new_state.game_state),
          )),
        )
      })

      new_state |> actor.continue
    }

    UserDisconnected(player) -> {
      //make other player disconnect
      list.each(state.participants, fn(participant) {
        case participant.0 == player {
          True -> {
            // they have already disconnected so can't send them a message
            Nil
          }
          _ -> {
            process.send(participant.1, Disconnect)
            Nil
          }
        }
      })
      actor.Stop(process.Abnormal("A player disconnected from the game"))
    }
  }
}

fn get_winning_player(state: GameState) -> String {
  //possible combinations of boxes marked to be a winner
  let lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ]
  case check_lines(lines, state) {
    Neither -> {
      case list.contains(state.state, Neither) {
        True -> "Neither"
        _ -> "Draw"
      }
    }
    player -> {
      case player {
        X -> "X"
        _ -> "O"
      }
    }
  }
}

fn check_lines(lines: List(List(Int)), state: GameState) -> Player {
  case lines {
    [first, ..rest] -> {
      let assert [a, b, c] = first
      let player = get_from_index(state.state, a)
      let res = case player {
        X | O -> {
          case
            player == get_from_index(state.state, b)
            && player == get_from_index(state.state, c)
          {
            True -> {
              player
            }
            _ -> {
              Neither
            }
          }
        }
        _ -> Neither
      }
      case res {
        Neither -> check_lines(rest, state)
        _ -> res
      }
    }
    [] -> Neither
  }
}

fn get_from_index(list: List(a), index: Int) -> a {
  let assert Ok(last) = list.first(list.split(list, index).1)
  last
}
