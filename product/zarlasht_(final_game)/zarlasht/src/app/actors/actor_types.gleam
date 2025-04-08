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
  /// Response to GetParticipants
  ///
  Participants(participants: List(#(Player, Subject(CustomWebsocketMessage))))
  /// Updates the state
  ///
  UpdatePlayerState(player: Player)
  /// Response to GetState for the game actor
  ///
  GameState(state: GameActorState)
  /// Read state
  ///
  GetStateWS(asking: Subject(CustomWebsocketMessage))
  /// response to GetStateWS
  ///
  StateWS(state: WebsocketActorState)
  /// The player was hit by the enemy they are in battle with
  ///
  PlayerGotHit(remove_health: Int)
  /// The battle has ended, their enemy has died and the player can continue moving on the trail
  ///
  YourEnemyDied
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
/// positions are x,y, where 0,0 is the top left corner of the map
///
pub type Player {
  Player(
    number: Int,
    name: String,
    color: String,
    health: Int,
    strength: Int,
    position: #(Int, Int),
    old_positions: List(#(Int, Int)),
    action: Action,
  )
}

/// The action the player needs to complete
///
pub type Action {
  /// The player is battling
  ///
  Battle(
    battle_type: BattleType,
    attack_type: Int,
    attack_damage: Int,
    defence_strategy: Int,
  )
  /// The player is moving through the map
  ///
  Move(amount_to_move: Int)
}

pub type BattleType {
  EnemyTribe(warrior_type: String)
  Cemetary
  Demon
  Ravine(warrior_type: String)
  Fog(player_num: Int)
  Ambush(warrior_type: String)
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
  /// Adds a Player to a waiting game
  ///
  EnqueueParticipant(
    game_code: Int,
    player: Player,
    participant_subject: Subject(CustomWebsocketMessage),
  )
  /// Deletes a Player from a waiting game
  ///
  DequeueParticipant(player: Player, game_code: Int)
  /// Update a waiting participant's data in director state
  ///
  UpdateParticipant(player: Player, game_code: Int)
  /// Deletes the game from state (as it is no longer waiting)
  ///
  GameStarted(game_code: Int)
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
/// pages_in_view is used to track what page a player is looking at (for updates)
///
pub type GameActorState {
  GameActorState(
    code: Int,
    participants: List(#(Player, Subject(CustomWebsocketMessage))),
    colors: List(String),
    used_colors: List(String),
    player_chats: Dict(#(Int, Int), List(Message)),
    ally_chats: Dict(List(Int), List(Message)),
    pages_in_view: Dict(Int, Page),
    ///id, battle_actor, player_number, optional second player number
    ///
    battles: List(#(Int, Subject(BattleActorMessage), Int, Option(Int))),
  )
}

pub type Page {
  Home
  Chat(chatting_to: Int)
  Map
  Dice
}

/// Message for a chat
///
pub type Message {
  Message(
    sender: Int,
    name: String,
    color: String,
    time: String,
    message: String,
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
  /// read state
  ///
  GetState(asking: Subject(CustomWebsocketMessage))
  /// Prepare the game as it is about to start
  ///
  PrepareGame
  /// A player has moved on the map
  ///
  /// They will possibly battle in the position they moved to;
  /// a battle actor will be started if so
  ///
  PlayerMoved(player: Player, game: Subject(GameActorMessage))
  /// Battle has ended
  ///
  BattleEnded(id: Int)
  /// A player hit their enemy in battle
  ///
  HitEnemy(player: Int, action: #(Int, Int, Int), strength: Int)
  /// A player has died in battle
  ///
  IDied(player: Int)
}

//----------------------------------------------------------------------

pub type BattleActorState {
  BattleActorState(
    id: Int,
    game: Option(Subject(GameActorMessage)),
    battle_type: BattleType,
    myself: Subject(BattleActorMessage),
    player_subject: Subject(CustomWebsocketMessage),
    enemy: Option(Subject(EnemyActorMessage)),
  )
}

pub type BattleActorMessage {
  SetupBattle(id: Int, game: Subject(GameActorMessage))
  /// Action tuple represents attack_type, attack_damage, defence_strategy
  ///
  EnemyHit(action: #(Int, Int, Int), strength: Int)
  /// Action tuple represents attack_type, attack_damage, defence_strategy
  ///
  PlayerHit(action: #(Int, Int, Int), strength: Int)
  EnemyDied
  PlayerDied
}

//----------------------------------------------------------------------

/// Action tuple represents attack_type, attack_damage, defence_strategy
///
pub type EnemyActorState {
  EnemyActorState(
    battle: Subject(BattleActorMessage),
    myself: Option(Subject(EnemyActorMessage)),
    me: EnemyType,
    health: Int,
    strength: Int,
    action: #(Int, Int, Int),
  )
}

pub type EnemyActorMessage {
  SetupEnemy(myself: Subject(EnemyActorMessage))
  MakeActions
  ShutdownEnemy
  EnemyGotHit(remove_health: Int)
}

pub type EnemyType {
  ExpertSwordsman
  DemonicSpirit
  Ghost
  Zombie
}
