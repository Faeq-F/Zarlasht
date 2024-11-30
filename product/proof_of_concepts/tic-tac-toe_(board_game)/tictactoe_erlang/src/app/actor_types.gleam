import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}
import mist

pub type CustomWebsocketMessage {
  JoinGame(game_subject: Subject(GameActorMessage), participants: List(String))
  SendToClient(message: String)
  Disconnect
}

pub type WebsocketActorState {
  WebsocketActorState(
    name: String,
    player: Player,
    ws_subject: Subject(CustomWebsocketMessage),
    game_subject: Option(Subject(GameActorMessage)),
    director_subject: Subject(DirectorActorMessage),
  )
}

pub type Player {
  X
  O
  Neither
}

pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: WebsocketActorState)
}

pub type GameActorMessage {
  DisconnectParticipant(participant_subject: Subject(CustomWebsocketMessage))
  SendToAll(general_message: GeneralMessage)
}

//Was Chat
pub type GeneralMessage {
  GeneralMessage(source: String, content: String)
}

pub type DirectorActorMessage {
  EnqueueParticipant(
    name: String,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  // maybe add player, etc.
  DequeueParticipant(participant_subject: Subject(CustomWebsocketMessage))
}
