//// Joining a game that has already been created

import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueParticipant,
  GetParticipants, Participants, Player, WebsocketActorState,
}
import app/pages/join_game.{incorrect_info, join_game_page}
import carpenter/table
import gleam/dict
import gleam/erlang/process
import gleam/int
import gleam/json.{int}
import gleam/list
import juno
import lustre/element
import mist

/// Asked to join a game
///
/// Sends the player to the `join_game_page`
///
pub fn on_to_join_game(player: PlayerSocket) -> WebsocketActorState {
  let assert Ok(_) = mist.send_text_frame(player.socket, join_game_page())
  player.state
}

/// After the game code has been inputted on the join page
///
/// Sends the player to the `set_name_page`
///
pub fn on_join_game(
  message: String,
  player: PlayerSocket,
) -> WebsocketActorState {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(game_code)) = message_dict |> dict.get("gameCode")
  case int.parse(game_code) {
    Ok(code) -> {
      let assert Ok(waiting_games) = table.ref("waiting_games")

      case waiting_games |> table.lookup(code) {
        [] -> {
          let assert Ok(_) =
            mist.send_text_frame(
              player.socket,
              incorrect_info() |> element.to_string,
            )
          player.state
        }
        _ -> {
          // The game has a player in it - it exists
          // get num
          let assert Participants(participants) =
            process.call_forever(player.state.director_subject, GetParticipants(
              _,
              code,
            ))
          let num = { participants |> list.length() } + 1
          //enqueue
          process.send(
            player.state.director_subject,
            EnqueueParticipant(
              code,
              Player(num, "Setting name...", "", 10, 1),
              player.state.ws_subject,
            ),
          )
          WebsocketActorState(
            ..player.state,
            player: Player(num, "Setting name...", "", 10, 1),
          )
        }
      }
    }
    _ -> {
      let assert Ok(_) =
        mist.send_text_frame(
          player.socket,
          incorrect_info() |> element.to_string,
        )
      player.state
    }
  }
}
