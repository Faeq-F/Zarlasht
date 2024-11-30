import app/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, Disconnect, DisconnectParticipant, GameActorState, JoinGame,
  SendToAll, SendToClient,
}
import gleam/erlang/process.{type Subject, Normal}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next, Stop}

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
  io.debug("room actor got message")
  io.debug(message)
  case message {
    SendToAll(general_message) -> {
      // let body_json = chat |> chat.to_json
      // let message_json = socket_message.custom_body_to_json("chat", body_json)
      let message = general_message.content
      list.each(state.participants, fn(p) {
        // send each participant's subject the message
        process.send(p.1, SendToClient(message))
      })

      state |> actor.continue
    }
    DisconnectParticipant(participant_subject) -> {
      let new_state =
        GameActorState(
          participants: list.filter(state.participants, fn(p) {
            case p.1 != participant_subject {
              True -> True
              False -> {
                io.println("Disconnected a user from a room")
                False
              }
            }
          }),
        )

      // Close the room if one or no participants left
      case new_state.participants {
        [] -> {
          io.println("No participants left. Closed a room actor")
          Stop(Normal)
        }
        [participant] -> {
          io.println("Only one participant left. Closed a room actor")

          process.send(participant.1, Disconnect)
          Stop(Normal)
        }
        _ -> new_state |> actor.continue
      }
    }
  }
}
