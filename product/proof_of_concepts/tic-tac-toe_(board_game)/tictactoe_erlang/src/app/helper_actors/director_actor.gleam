import app/actor_types.{
  type CustomWebsocketMessage, type DirectorActorMessage, DequeueParticipant,
  EnqueueParticipant,
}
import app/helper_actors/game_actor
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}

pub opaque type QueueActorState {
  QueueActorState(queue: List(#(String, Subject(CustomWebsocketMessage))))
}

pub fn start() -> Subject(DirectorActorMessage) {
  let assert Ok(actor) = actor.start(QueueActorState([]), handle_message)
  actor
}

fn handle_message(
  message: DirectorActorMessage,
  state: QueueActorState,
) -> Next(DirectorActorMessage, QueueActorState) {
  case message {
    EnqueueParticipant(name, user_subject) -> {
      io.println("Enqueued a user")

      let participant = #(name, user_subject)
      let new_queue = case state.queue {
        [] -> [participant]
        [first] -> {
          io.debug("room actor started in queue actor")
          game_actor.start([first, participant])
          []
        }
        [first, second, ..rest] -> {
          game_actor.start([first, second])
          list.append(rest, [participant])
        }
      }
      let new_state = QueueActorState(queue: new_queue)

      new_state |> actor.continue
    }
    DequeueParticipant(user_subject) -> {
      let new_queue = list.filter(state.queue, fn(p) { p.1 != user_subject })
      let new_state = QueueActorState(queue: new_queue)

      new_state |> actor.continue
    }
  }
}
