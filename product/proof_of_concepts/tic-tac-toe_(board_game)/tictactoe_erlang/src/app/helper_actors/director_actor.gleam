import app/actor_types.{
  type CustomWebsocketMessage, type DirectorActorMessage,
  type DirectorActorState, DequeueParticipant, DirectorActorState,
  EnqueueParticipant,
}
import app/helper_actors/game_actor
import gleam/dict.{drop, get, insert}
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}

pub fn start() -> Subject(DirectorActorMessage) {
  let assert Ok(actor) =
    actor.start(DirectorActorState(dict.new()), handle_message)
  actor
}

fn handle_message(
  message: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message {
    EnqueueParticipant(game_code, player, participant_subject) -> {
      let participant = #(player, participant_subject)
      let new_queue = case state.games_waiting |> get(game_code) {
        Ok(first_participant) -> {
          //They are joining a Game
          game_actor.start([participant, ..first_participant])
          state.games_waiting |> drop([game_code])
        }
        _ -> {
          //They created the game
          state.games_waiting |> insert(game_code, [participant])
        }
      }
      let new_state = DirectorActorState(games_waiting: new_queue)

      new_state |> actor.continue
    }
    DequeueParticipant(participant_subject) -> {
      // let new_queue = list.filter(state.queue, fn(p) { p.1 != user_subject })
      // let new_state = QueueActorState(queue: new_queue)
      //reload other persons page by sending a message to the room actor
      // new_state |> actor.continue
      state |> actor.continue
    }
  }
}
