import app/web.{type Context}
import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import mist

pub type WebsocketActorState {
  WebsocketActorState(
    name: String,
    chat_code: Int,
    ws_subject: Subject(CustomWebsocketMessage),
    director_subject: Subject(DirectorActorMessage),
    context: Context,
  )
}

pub type CustomWebsocketMessage {
  SendToClient(message: String)
}

pub type UserSocket {
  UserSocket(socket: mist.WebsocketConnection, state: WebsocketActorState)
}

//----------------------------------------------------------------------

pub type DirectorActorState {
  DirectorActorState(
    chats: Dict(Int, List(#(String, Subject(CustomWebsocketMessage)))),
  )
}

pub type DirectorActorMessage {
  AddParticipant(
    chat_code: Int,
    user_name: String,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  RemoveParticipant(chat_code: Int, user_name: String)
  SentMessage(chat_code: Int, text: String, user_name: String)
}
