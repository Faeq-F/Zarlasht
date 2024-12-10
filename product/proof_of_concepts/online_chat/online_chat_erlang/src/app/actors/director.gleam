import app/actors/actor_types.{
  type DirectorActorMessage, type DirectorActorState, AddParticipant,
  DirectorActorState, RemoveParticipant, SendToClient, SentMessage,
}

import app/pages/chat.{message}
import birl.{now, to_naive_date_string, to_naive_time_string}
import gleam/dict.{get, insert}
import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor.{type Next}

pub fn start() -> Subject(DirectorActorMessage) {
  let assert Ok(actor) =
    actor.start(DirectorActorState(dict.new()), handle_message)
  actor
}

fn handle_message(
  message_text: DirectorActorMessage,
  state: DirectorActorState,
) -> Next(DirectorActorMessage, DirectorActorState) {
  case message_text {
    AddParticipant(chat_code, user_name, participant_subject) -> {
      let participant = #(user_name, participant_subject)
      let chats = case state.chats |> get(chat_code) {
        Ok(participants) -> {
          //already exists
          state.chats |> insert(chat_code, [participant, ..participants])
        }
        _ -> {
          //doesn't exist
          state.chats |> insert(chat_code, [participant])
        }
      }

      let new_state = DirectorActorState(chats: chats)
      new_state |> actor.continue
    }

    RemoveParticipant(chat_code, user_name) -> {
      case chat_code {
        0 -> state |> actor.continue
        _ -> {
          let assert Ok(old_list) =
            state.chats
            |> get(chat_code)

          let new_list =
            old_list
            |> list.filter(fn(participant) { participant.0 != user_name })

          let chats = state.chats |> insert(chat_code, new_list)

          let new_state = DirectorActorState(chats: chats)
          new_state |> actor.continue
        }
      }
    }

    SentMessage(chat_code, message_text, from_user) -> {
      let assert Ok(participants) =
        state.chats
        |> get(chat_code)
      list.each(participants, fn(p) {
        case p.0 == from_user {
          True -> {
            process.send(
              p.1,
              SendToClient(message(
                message_text,
                from_user,
                to_naive_date_string(now()),
                to_naive_time_string(now()),
                True,
              )),
            )
          }
          _ -> {
            process.send(
              p.1,
              SendToClient(message(
                message_text,
                from_user,
                to_naive_date_string(now()),
                to_naive_time_string(now()),
                False,
              )),
            )
          }
        }
      })
      state |> actor.continue
    }
  }
}
