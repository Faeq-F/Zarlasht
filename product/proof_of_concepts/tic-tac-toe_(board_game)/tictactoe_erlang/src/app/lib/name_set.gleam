//// Setting the name of a user

import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, AddedName, WebsocketActorState,
}
import app/pages/set_name.{empty_name}
import gleam/dict
import gleam/erlang/process
import gleam/option.{Some}
import juno
import mist

/// Set a player's name
///
/// Also sends the player to the game page
///
pub fn set_name(message: String, player: PlayerSocket) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(name)) = message_dict |> dict.get("name")
  case name {
    "" -> {
      let assert Ok(_) = mist.send_text_frame(player.socket, empty_name())
      player.state
    }
    _ -> {
      let assert Some(game_subject) = player.state.game_subject
      process.send(
        game_subject,
        AddedName(player.state.player, player.state.ws_subject, name),
      )
      WebsocketActorState(..player.state, name: name)
    }
  }
}
