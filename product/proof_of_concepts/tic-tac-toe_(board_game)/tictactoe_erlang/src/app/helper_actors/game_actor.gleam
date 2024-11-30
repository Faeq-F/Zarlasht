import app/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, Disconnect,
  DisconnectParticipant, JoinGame, SendToAll, SendToClient,
}
import gleam/erlang/process.{type Subject, Normal}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next, Stop}

pub opaque type RoomActorState {
  RoomActorState(participants: List(#(String, Subject(CustomWebsocketMessage))))
}

//name, subject
pub fn start(
  participants: List(#(String, Subject(CustomWebsocketMessage))),
) -> Subject(GameActorMessage) {
  io.println("Started new room actor")

  let state = RoomActorState(participants: participants)
  io.debug("started another actor from room_actor")
  let assert Ok(actor) = actor.start(state, handle_message)

  // Tell participants they have been put into a room
  io.debug(
    "sent a participant (after checking for the right one) joint_room using the new actor as a subject",
  )
  list.each(participants, fn(participant) {
    process.send(
      participant.1,
      //the second item (index)
      JoinGame(
        game_subject: actor,
        participants: participants
          |> list.filter_map(fn(p) {
            case p.1 != participant.1 {
              True -> Ok(p.0)
              False -> Error(Nil)
            }
          }),
      ),
    )
  })

  actor
}

fn handle_message(
  message: GameActorMessage,
  state: RoomActorState,
) -> Next(GameActorMessage, RoomActorState) {
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
        RoomActorState(
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
