import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}
import mist

pub type WebsocketActorState {
  WebsocketActorState(
    name: String,
    game_code: Int,
    player: Player,
    ws_subject: Subject(CustomWebsocketMessage),
    game_subject: Option(Subject(GameActorMessage)),
    director_subject: Subject(DirectorActorMessage),
  )
}

pub type CustomWebsocketMessage {
  JoinGame(game_subject: Subject(GameActorMessage))
  SendToClient(message: String)
  Wait
  Disconnect
}

pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: WebsocketActorState)
}

pub type Player {
  One
  Two
  Neither
}

//----------------------------------------------------------------------

pub type DirectorActorState {
  DirectorActorState(
    games_waiting: Dict(Int, List(#(Player, Subject(CustomWebsocketMessage)))),
  )
}

pub type DirectorActorMessage {
  EnqueueParticipant(
    game_code: Int,
    player: Player,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  DequeueParticipant(game_code: Int)
}

//----------------------------------------------------------------------

pub type GameActorState {
  GameActorState(
    participants: List(#(Player, Subject(CustomWebsocketMessage))),
    names_set: Int,
    player_one_name: String,
    player_two_name: String,
  )
}

pub type GameActorMessage {
  UserDisconnected(player: Player)
  AddedName(player: Player, ws: Subject(CustomWebsocketMessage), name: String)
  SendToAll(general_message: GeneralMessage)
}

pub type GeneralMessage {
  GeneralMessage(source: String, content: String)
}
