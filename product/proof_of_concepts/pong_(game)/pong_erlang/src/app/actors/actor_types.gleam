//// All types relating to the different actors

import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}
import mist

/// The state for a WebSocket Actor
///
/// The game_subject field will get filled when the player joins a game
///
pub type WebsocketActorState {
  WebsocketActorState(
    game_code: Int,
    ws_subject: Subject(CustomWebsocketMessage),
    game_subject: Option(Subject(GameActorMessage)),
    director_subject: Subject(DirectorActorMessage),
  )
}

/// Custom messages for the WebSocket actor
///
pub type CustomWebsocketMessage {
  ///Send a message to the client
  ///
  /// (usually HTML for htmx)
  ///
  SendToClient(message: String)
  ///Fills the game_subject filed for the user when they are in a game
  ///
  JoinGame(game_subject: Subject(GameActorMessage))
}

/// A wrapper for a player's WebSocket Actor state and their connection
///
pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: WebsocketActorState)
}

//----------------------------------------------------------------------

/// The state for the Director Actor
///
/// Holds all games managed by this server
///
pub type DirectorActorState {
  DirectorActorState(games: Dict(Int, Subject(CustomWebsocketMessage)))
}

/// Custom message for the Director actor
///
pub type DirectorActorMessage {
  ///Adds a game for a user
  ///
  EnqueueUser(
    game_code: Int,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  ///Deletes a game
  ///
  DequeueUser(game_code: Int)
}

//----------------------------------------------------------------------

/// The state for the Game actor
///
/// Contains all participants in the game
///
pub type GameActorState {
  GameActorState(
    user: Subject(CustomWebsocketMessage),
    player1name: String,
    player2name: String,
  )
}

///Custom message for the Game actor
///
pub type GameActorMessage {
  /// The user disconnected
  ///
  UserDisconnected
  /// The players have set their names
  ///
  SetNames(player1name: String, player2name: String)
}
