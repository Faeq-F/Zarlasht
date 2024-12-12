//// State types for WebSockets connected to the site

/// State for a WebSocket connected to the site
///
/// stores information about the game; `game_code` & the `player` (X or O) of the person connected
///
pub type State {
  //player arg represents the enum in js ffi
  State(game_code: Int, player: String)
}

/// Events a WebSocket can fire
///
/// Currently `Mark`
///
pub type Event {
  Mark
}
