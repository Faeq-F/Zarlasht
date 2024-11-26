import gleam/option.{type Option}
import mist

pub type MessageHTMX {
  MessageHTMX(headers: String)
}

pub type HEADERS {
  HEADERS(
    hx_request: Bool,
    hx_trigger: String,
    hx_trigger_name: Option(String),
    hx_target: String,
    hx_current_url: String,
  )
}

pub type CustomMessage {
  Broadcast(String)
}

pub type ActorState {
  ActorState(player: Player, name: String)
}

pub type Player {
  X
  O
  Neither
}

pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: ActorState)
}
