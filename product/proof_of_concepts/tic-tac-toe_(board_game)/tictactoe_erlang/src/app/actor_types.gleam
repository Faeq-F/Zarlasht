import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}
import mist

pub type CustomWebsocketMessage {
  JoinGame(game_subject: Subject(GameActorMessage))
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
    game_code: Int,
    player: Player,
    participant_subject: Subject(CustomWebsocketMessage),
  )

  DequeueParticipant(participant_subject: Subject(CustomWebsocketMessage))
}

pub type DirectorActorState {
  DirectorActorState(
    games_waiting: Dict(Int, List(#(Player, Subject(CustomWebsocketMessage)))),
  )
}

pub type GameActorState {
  GameActorState(participants: List(#(Player, Subject(CustomWebsocketMessage))))
}
