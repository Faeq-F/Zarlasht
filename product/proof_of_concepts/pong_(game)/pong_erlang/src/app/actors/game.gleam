import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, AddedName, Disconnect, GameActorState, JoinGame, One, SendToAll,
  SendToClient, Two, UserDisconnected, Wait,
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
            //update player names
            process.send(
              p.1,
              SendToClient(game.player(One, new_state.player_one_name)),
            )
            process.send(
              p.1,
              SendToClient(game.player(Two, new_state.player_two_name)),
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
