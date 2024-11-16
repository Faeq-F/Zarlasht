//// State types for WebSockets connected to the site

/// State for a WebSocket connected to the site
///
/// stores information about the chat; `chat_code` & the `username` of the person connected
///
pub type State {
  State(chat_code: Int, username: String)
}

/// Events a WebSocket can fire
///
/// Currently `SendMessage`
///
pub type Event {
  SendMessage
}
