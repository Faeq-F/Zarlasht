import app/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, Disconnect, GameActorState, JoinGame, SendToAll, SendToClient,
  UserDisconnected,
}
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}

pub fn start(
  participants: List(#(Player, Subject(CustomWebsocketMessage))),
) -> Subject(GameActorMessage) {
  let state = GameActorState(participants: participants)
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
