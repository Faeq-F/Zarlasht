//// Setting the name of a user

import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, AddedName, Player,
  UpdateParticipant, WebsocketActorState,
}
import app/pages/set_name.{incorrect_info}
import gleam/dict
import gleam/erlang/process
import gleam/option.{Some}
import juno
import lustre/element
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
      let assert Ok(_) =
        mist.send_text_frame(
          player.socket,
          incorrect_info() |> element.to_string,
        )
      player.state
    }
    _ -> {
      let new_player_info = Player(..player.state.player, name: name)
      process.send(
        player.state.director_subject,
        UpdateParticipant(new_player_info, player.state.game_code),
      )
      let assert Some(game_subject) = player.state.game_subject
      process.send(
        game_subject,
        AddedName(player.state.player, game_subject, name),
      )
      WebsocketActorState(..player.state, player: new_player_info)
    }
  }
}
