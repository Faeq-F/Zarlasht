//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  GameActorState, JoinGame, SendToClient, SetNames, UserDisconnected,
}
import app/pages/game.{game_page}
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/list
import gleam/otp/actor.{type Next}
import logging.{Info}

/// Creates the actor
///
pub fn start(user: Subject(CustomWebsocketMessage)) -> Subject(GameActorMessage) {
  let state = GameActorState(user: user, player1name: "", player2name: "")
  let assert Ok(actor) = actor.start(state, handle_message)
  //send them to the set_name page
  process.send(user, JoinGame(game_subject: actor))
  actor
}

///Handle all messages  from other Actors
///
fn handle_message(
  message: GameActorMessage,
  state: GameActorState,
) -> Next(GameActorMessage, GameActorState) {
  logging.log(Info, "A Game Actor got the message")
  io.debug(message)
  case message {
    SetNames(player1name, player2name) -> {
      let new_state =
        GameActorState(
          ..state,
          player1name: player1name,
          player2name: player2name,
        )
      process.send(
        state.user,
        SendToClient(game.game_page(player1name, player2name)),
      )
      new_state |> actor.continue
    }

    UserDisconnected -> {
      actor.Stop(process.Abnormal("User disconnected from the game"))
    }
  }
}
