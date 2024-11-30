import app/actor_types.{
  type PlayerSocket, type WebsocketActorState, EnqueueParticipant,
  WebsocketActorState, X,
}
import app/pages/created_game.{created_game_page}
import carpenter/table
import gleam/erlang/process
import gleam/int
import logging.{Info}
import mist

pub fn on_create_game(player: PlayerSocket) -> WebsocketActorState {
  let game_code = generate_game_code(player)
  process.send(
    player.state.director_subject,
    EnqueueParticipant(game_code, X, player.state.ws_subject),
  )
  let assert Ok(_) =
    mist.send_text_frame(player.socket, created_game_page(game_code))
  WebsocketActorState(..player.state, player: X)
}

fn generate_game_code(player: PlayerSocket) -> Int {
  // let assert Ok(game_sockets) = table.ref("game_sockets")
  let game_code = int.random(9999)
  // Games with the same codes can exist - just cannot be waiting for a joining player at the same time
  //check directors state for key (game_code) existing - maybe try call

  // case game_sockets |> table.lookup(game_code) {
  //   [] -> {
  //     game_sockets
  //     |> table.insert([#(game_code, [player])])
  //     logging.log(Info, "New game created; " <> int.to_string(game_code))
  //     game_code
  //   }
  //   _ -> generate_game_code(player)
  // }
}
