import app/actors/actor_types.{
  type PlayerSocket, type WebsocketActorState, AddedName, GameStarted,
  GetParticipants, Participants, Player, WebsocketActorState,
}
import app/pages/created_game.{info_error_player_count, info_error_setting_name}
import gleam/dict
import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import juno
import lustre/element
import mist

pub fn start_game(player: PlayerSocket) {
  let assert Participants(participants) =
    process.call_forever(player.state.director_subject, GetParticipants(
      _,
      player.state.game_code,
    ))
  //TODO - DEPLOYMENT
  //change to 5 in deployment
  case participants |> list.length() == 2 {
    True -> {
      //check they have all set their name
      case
        participants
        |> list.filter(fn(pl) { { pl.0 }.name == "Setting name..." })
        |> list.length()
        == 0
      {
        True -> {
          // tell everyone to go to the game page
          // & delete game from waiting table & director state
          process.send(
            player.state.director_subject,
            GameStarted(player.state.game_code),
          )
          Nil
        }
        _ -> {
          let assert Ok(_) =
            mist.send_text_frame(
              player.socket,
              info_error_setting_name() |> element.to_string,
            )
          Nil
        }
      }
      Nil
    }
    _ -> {
      //send them need 5 players
      let assert Ok(_) =
        mist.send_text_frame(
          player.socket,
          info_error_player_count() |> element.to_string,
        )
      Nil
    }
  }
  player.state
}
