//// All types relating to the different actors

import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/option.{type Option}
import juno
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

pub type ExtraInfo {
  ExtraInfo(
    board_coord: Rect,
    window_inner_height: Float,
    paddle_1_coord: Rect,
    paddle_2_coord: Rect,
    paddle_common: Rect,
  )
}

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
// "{\"extraInfo\":\"{
//   \\\"board_coord\\\":{
//     \\\"x\\\":152.796875,
//     \\\"y\\\":68.25,
//     \\\"width\\\":1222.390625,
//     \\\"height\\\":773.5,
//     \\\"top\\\":68.25,
//     \\\"right\\\":1375.1875,
//     \\\"bottom\\\":841.75,
//     \\\"left\\\":152.796875},
//   \\\"window_innerHeight\\\":910,
//   \\\"paddle_1_coord\\\":{
//     \\\"x\\\":182.796875,
//     \\\"y\\\":68.640625,
//     \\\"width\\\":18,
//     \\\"height\\\":100,
//     \\\"top\\\":68.640625,
//     \\\"right\\\":200.796875,
//     \\\"bottom\\\":168.640625,
//     \\\"left\\\":182.796875},
//   \\\"paddle_2_coord\\\":{
//     \\\"x\\\":1327.203125,
//     \\\"y\\\":686.75,
//     \\\"width\\\":18,
//     \\\"height\\\":100,
//     \\\"top\\\":686.75,
//     \\\"right\\\":1345.203125,
//     \\\"bottom\\\":786.75,
//     \\\"left\\\":1327.203125},
//   \\\"paddle_common\\\":{
//     \\\"x\\\":182.796875,
//     \\\"y\\\":123.25,
//     \\\"width\\\":18,
//     \\\"height\\\":100,
//     \\\"top\\\":123.25,
//     \\\"right\\\":200.796875,
//     \\\"bottom\\\":223.25,
//     \\\"left\\\":182.796875}}\"
