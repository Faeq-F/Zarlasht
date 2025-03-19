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
    player: Player,
    ws_subject: Subject(CustomWebsocketMessage),
    game_subject: Option(Subject(GameActorMessage)),
    director_subject: Subject(DirectorActorMessage),
  )
}

/// Custom messages for the WebSocket actor
///
pub type CustomWebsocketMessage {
  /// 2 players have joined
  ///
  /// Send the player to the game page
  ///
  JoinGame(game_subject: Subject(GameActorMessage))
  ///Send a message to the client
  ///
  /// (usually HTML for htmx)
  ///
  SendToClient(message: String)
  ///Waiting for the other player to enter their name
  ///
  /// Sends the player a message to indicate this
  ///
  Wait
  /// The other player has disconnected
  ///
  /// Send this player an alert and then disconnect them too
  ///
  Disconnect
  /// Response to GetParticipants
  ///
  Participants(participants: List(#(Player, Subject(CustomWebsocketMessage))))
  ///
  ///
  UpdatePlayerState(player: Player)
}

/// A wrapper for a player's WebSocket Actor state and their connection
///
pub type PlayerSocket {
  PlayerSocket(socket: mist.WebsocketConnection, state: WebsocketActorState)
}

/// The player a user is
///
/// number is 1 if they are the creator of the game, 2 if they are the first to join, 3 if they are the second to join, etc.
///
pub type Player {
  Player(number: Int, name: String, color: String, health: Int, strength: Int)
}

//----------------------------------------------------------------------

/// The state for the Director Actor
///
/// Holds all games managed by this server
///
pub type DirectorActorState {
  DirectorActorState(
    games_waiting: Dict(
      Int,
      #(
        Subject(GameActorMessage),
        List(#(Player, Subject(CustomWebsocketMessage))),
      ),
    ),
  )
}

/// Custom message for the Director actor
///
pub type DirectorActorMessage {
  /// Adds a Player to a game
  ///
  EnqueueParticipant(
    game_code: Int,
    player: Player,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  /// Deletes a Player from a game
  ///
  DequeueParticipant(game_code: Int)
  /// Asks for the director to send the list of participants waiting for a game
  ///
  GetParticipants(asking: Subject(CustomWebsocketMessage), game_code: Int)
}

//----------------------------------------------------------------------

/// The state for the Game actor
///
/// Contains all participants in the game
///
/// The colors are for identifying users (specifically for deciding which colors to use - not important for actual gameplay)
///
/// The code is only used while the game is waiting for players to join
///
pub type GameActorState {
  GameActorState(
    code: Int,
    participants: List(#(Player, Subject(CustomWebsocketMessage))),
    colors: List(String),
    used_colors: List(String),
  )
}

///Custom message for the Game actor
///
pub type GameActorMessage {
  /// A player hqas joined the game
  ///
  AddPlayer(
    player: #(Player, Subject(CustomWebsocketMessage)),
    game_subject: Subject(GameActorMessage),
  )
  /// A player disconnected
  ///
  /// disconnects the other player after alerting them
  ///
  UserDisconnected(player: Player)
  /// A player has set their name
  ///
  AddedName(
    player: Player,
    game_subject: Subject(GameActorMessage),
    name: String,
  )
  /// Update the colors players use - a client swapped colors around
  ///
  SwapColors(colors: List(String), game_subject: Subject(GameActorMessage))
  /// Allow state updates
  ///
  UpdateState(state: GameActorState)
}
