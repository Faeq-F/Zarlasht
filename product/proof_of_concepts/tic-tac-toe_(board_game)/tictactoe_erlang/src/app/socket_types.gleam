import gleam/erlang/process.{type Subject}
import mist

pub type CustomMessage {
  Broadcast(String)
  ActorMessage(String)
}

pub type ActorState {
  ActorState(player: Player, name: String, subject: Subject(CustomMessage))
}

pub type Player {
  X
  O
  Neither
}

pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: ActorState)
}
