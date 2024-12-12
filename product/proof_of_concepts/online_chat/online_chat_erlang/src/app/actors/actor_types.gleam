//// All types relating to the different actors

import app/web.{type Context}
import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import mist

/// The state for a WebSocket Actor - all fields are necessary
///
pub type WebsocketActorState {
  WebsocketActorState(
    name: String,
    chat_code: Int,
    ws_subject: Subject(CustomWebsocketMessage),
    director_subject: Subject(DirectorActorMessage),
    context: Context,
  )
}

/// Custom message for the WebSocket actor
///
/// Sends the message to the client
///
pub type CustomWebsocketMessage {
  SendToClient(message: String)
}

/// A wrapper for a user's WebSocket Actor state and their connection
///
pub type UserSocket {
  UserSocket(socket: mist.WebsocketConnection, state: WebsocketActorState)
}

//----------------------------------------------------------------------

/// The state for the Director Actor
///
/// Holds all chats managed by this server
///
pub type DirectorActorState {
  DirectorActorState(
    chats: Dict(Int, List(#(String, Subject(CustomWebsocketMessage)))),
  )
}

/// Custom message for the Director actor
///
pub type DirectorActorMessage {
  ///Adds a User to a chat
  ///
  AddParticipant(
    chat_code: Int,
    user_name: String,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  ///Deletes a User from a chat
  ///
  RemoveParticipant(chat_code: Int, user_name: String)
  ///Sends all users in a chat, a message
  ///
  SentMessage(chat_code: Int, text: String, user_name: String)
}
