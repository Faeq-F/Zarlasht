//// All types relating to the different actors

import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}
import mist

/// The state for a WebSocket Actor
///
/// The game_subject field will get filled when the player joins a game
///
pub type WebsocketActorState {
  WebsocketActorState(
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
/// Holds all games (connections) managed by this server
///
pub type DirectorActorState {
  DirectorActorState
}

/// Custom message for the Director actor
///
pub type DirectorActorMessage {
  ///Adds a game for a user
  ///
  EnqueueUser(participant_subject: Subject(CustomWebsocketMessage))
}

//----------------------------------------------------------------------

/// The state for a game
///
pub type GameState {
  Start
  Play
}

/// The state for the Game actor
///
pub type GameActorState {
  GameActorState(
    user: Subject(CustomWebsocketMessage),
    player1name: String,
    player2name: String,
    state: GameState,
    player1score: Int,
    player2score: Int,
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
  /// User hit the enter key
  ///
  EnterHit(message: String)
  /// User hit the W key
  ///
  WHit(message: String)
  /// User hit the S key
  ///
  SHit(message: String)
  /// User hit the Up key
  ///
  UpHit(message: String)
  /// User hit the Down key
  ///
  DownHit(message: String)
}

/// The JSON information appended to websocket messages when the user is playing the game
///
pub type ExtraInfo {
  ExtraInfo(
    board_coord: Rect,
    window_inner_height: Float,
    paddle_1_coord: Rect,
    paddle_2_coord: Rect,
    paddle_common: Rect,
    player_1_score: Int,
    player_2_score: Int,
  )
}

/// The bounding rectangle of a DOM object
///
pub type Rect {
  Rect(
    x: Float,
    y: Float,
    width: Float,
    height: Float,
    top: Float,
    right: Float,
    bottom: Float,
    left: Float,
  )
}

pub type LeaderboardInformation {
  LeaderboardInformation(
    player1name: String,
    player2name: String,
    player1score: Int,
    player2score: Int,
  )
}
