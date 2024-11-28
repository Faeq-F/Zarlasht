import gleam/erlang/process.{type Subject}
import mist

pub type CustomMessage {
  Broadcast(String)
}

pub type ActorState {
  ActorState(player: Player, name: String, subject: Subject(String))
}

pub type Player {
  X
  O
  Neither
}

pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: ActorState)
}
