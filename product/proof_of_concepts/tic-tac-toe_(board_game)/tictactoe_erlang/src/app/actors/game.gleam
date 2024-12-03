import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type GameState, type Player, AddedName, Disconnect, GameActorState, GameState,
  JoinGame, Neither, O, SendToAll, SendToClient, UserDisconnected, Wait, X,
}
import app/pages/game.{game_page}
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
  message: GameActorMessage,
  state: GameActorState,
) -> Next(GameActorMessage, GameActorState) {
  logging.log(Info, "A Game Actor got the message")
  io.debug(message)
  case message {
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

    SendToAll(general_message) -> {
      let message = general_message.content
      list.each(state.participants, fn(p) {
        // send each participant's subject the message
        process.send(p.1, SendToClient(message))
      })

      state |> actor.continue
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

fn get_winning_player(state: GameState) {
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

fn check_lines(lines: List(List(Int)), state: GameState) {
  case lines {
    [first, ..rest] -> {
      let assert [a, b, c] = first
      let player = get_from_index(state.state, a)
      case player {
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

      check_lines(rest, state)
    }
    [] -> Neither
  }
}

fn get_from_index(list: List(a), index: Int) -> a {
  let assert Ok(last) = list.first(list.split(list, index).1)
  last
}
