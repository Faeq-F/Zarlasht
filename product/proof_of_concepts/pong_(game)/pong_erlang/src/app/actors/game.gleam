//// The game actor - process to manage a single game being played between two players

import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  DownHit, EnterHit, ExtraInfo, GameActorState, JoinGame, LeaderboardInformation,
  Play, Rect, SHit, SendToClient, SetNames, Start, UpHit, UserDisconnected, WHit,
}
import app/pages/game.{inject_js, instruction}
import carpenter/table
import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/erlang/process.{type Subject}
import gleam/float
import gleam/int.{parse, to_float}
import gleam/io
import gleam/otp/actor.{type Next}
import gleam/string
import juno
import logging.{Info}
import lustre/element

/// Creates the actor
///
pub fn start(user: Subject(CustomWebsocketMessage)) -> Subject(GameActorMessage) {
  let state =
    GameActorState(
      user: user,
      player1name: "",
      player2name: "",
      state: Start,
      player1score: 0,
      player2score: 0,
    )
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
    EnterHit(message) -> {
      case state.state {
        Start -> {
          process.send(
            state.user,
            SendToClient(instruction(False) |> element.to_string),
          )
          process.send(
            state.user,
            SendToClient(
              inject_js(
                "
                requestAnimationFrame(() => {
                  dx = Math.floor(Math.random() * 4) + 3;
                  dy = Math.floor(Math.random() * 4) + 3;
                  dxd = Math.floor(Math.random() * 2);
                  dyd = Math.floor(Math.random() * 2);
                  moveBall(dx, dy, dxd, dyd);
                });
              ",
              )
              |> element.to_string,
            ),
          )
          GameActorState(..state, state: Play) |> actor.continue
        }
        _ -> {
          //Save current score
          let extra_info_dict = get_extra_info_dict(message)
          let assert Ok(juno.String(player1score_string)) =
            extra_info_dict |> dict.get("player_1_score")
          let assert Ok(juno.String(player2score_string)) =
            extra_info_dict |> dict.get("player_2_score")
          let assert Ok(player1score) = parse(player1score_string)
          let assert Ok(player2score) = parse(player2score_string)
          //Let the player get ready
          process.send(
            state.user,
            SendToClient(instruction(True) |> element.to_string),
          )
          GameActorState(
            ..state,
            state: Start,
            player1score: player1score,
            player2score: player2score,
          )
          |> actor.continue
        }
      }
    }

    WHit(message) -> {
      let extra_info_dict = get_extra_info_dict(message)

      let assert Ok(juno.Object(board_coord_dict)) =
        extra_info_dict |> dict.get("board_coord")
      let board_coord_top = get_juno_value_as_float(board_coord_dict, "top")

      let assert Ok(juno.Object(paddle1_coord_dict)) =
        extra_info_dict |> dict.get("paddle_1_coord")
      let paddle1_coord_top = get_juno_value_as_float(paddle1_coord_dict, "top")

      let window_inner_height =
        get_juno_value_as_float(extra_info_dict, "window_innerHeight")

      process.send(
        state.user,
        SendToClient(
          inject_js("
                paddle_1.style.top = \"" <> float.to_string(
            float.max(board_coord_top, {
              paddle1_coord_top -. window_inner_height *. 0.12
            }),
          ) <> "px\"" <> ";
                paddle_1_coord = paddle_1.getBoundingClientRect();
              ")
          |> element.to_string,
        ),
      )

      state |> actor.continue
    }
    SHit(message) -> {
      let extra_info_dict = get_extra_info_dict(message)

      let assert Ok(juno.Object(board_coord_dict)) =
        extra_info_dict |> dict.get("board_coord")
      let board_coord_bottom =
        get_juno_value_as_float(board_coord_dict, "bottom")

      let assert Ok(juno.Object(paddle1_coord_dict)) =
        extra_info_dict |> dict.get("paddle_1_coord")
      let paddle1_coord_top = get_juno_value_as_float(paddle1_coord_dict, "top")

      let assert Ok(juno.Object(paddle_common_dict)) =
        extra_info_dict |> dict.get("paddle_common")
      let paddle_common_height =
        get_juno_value_as_float(paddle_common_dict, "height")

      let window_inner_height =
        get_juno_value_as_float(extra_info_dict, "window_innerHeight")

      process.send(
        state.user,
        SendToClient(
          inject_js("
                paddle_1.style.top =\"" <> float.to_string(
            float.min(board_coord_bottom -. paddle_common_height, {
              paddle1_coord_top +. window_inner_height *. 0.12
            }),
          ) <> "px\"" <> ";
          paddle_1_coord = paddle_1.getBoundingClientRect();
              ")
          |> element.to_string,
        ),
      )

      state |> actor.continue
    }
    UpHit(message) -> {
      let extra_info_dict = get_extra_info_dict(message)

      let assert Ok(juno.Object(board_coord_dict)) =
        extra_info_dict |> dict.get("board_coord")
      let board_coord_top = get_juno_value_as_float(board_coord_dict, "top")

      let assert Ok(juno.Object(paddle2_coord_dict)) =
        extra_info_dict |> dict.get("paddle_2_coord")
      let paddle2_coord_top = get_juno_value_as_float(paddle2_coord_dict, "top")

      let window_inner_height =
        get_juno_value_as_float(extra_info_dict, "window_innerHeight")

      process.send(
        state.user,
        SendToClient(
          inject_js("
                paddle_2.style.top =\"" <> float.to_string(
            float.max(board_coord_top, {
              paddle2_coord_top -. window_inner_height *. 0.12
            }),
          ) <> "px\"" <> ";
                paddle_2_coord = paddle_2.getBoundingClientRect();
              ")
          |> element.to_string,
        ),
      )

      state |> actor.continue
    }
    DownHit(message) -> {
      let extra_info_dict = get_extra_info_dict(message)

      let assert Ok(juno.Object(board_coord_dict)) =
        extra_info_dict |> dict.get("board_coord")
      let board_coord_bottom =
        get_juno_value_as_float(board_coord_dict, "bottom")

      let assert Ok(juno.Object(paddle2_coord_dict)) =
        extra_info_dict |> dict.get("paddle_2_coord")
      let paddle2_coord_top = get_juno_value_as_float(paddle2_coord_dict, "top")

      let assert Ok(juno.Object(paddle_common_dict)) =
        extra_info_dict |> dict.get("paddle_common")
      let paddle_common_height =
        get_juno_value_as_float(paddle_common_dict, "height")

      let window_inner_height =
        get_juno_value_as_float(extra_info_dict, "window_innerHeight")

      process.send(
        state.user,
        SendToClient(
          inject_js("
                paddle_2.style.top =\"" <> float.to_string(
            float.min(board_coord_bottom -. paddle_common_height, {
              paddle2_coord_top +. window_inner_height *. 0.12
            }),
          ) <> "px\"" <> ";
                paddle_2_coord = paddle_2.getBoundingClientRect();
              ")
          |> element.to_string,
        ),
      )

      state |> actor.continue
    }

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
      io.debug("User disconnected from the game")
      //save names & scores to ETS table (as cache) and Valkey db (long-term storage)
      let assert Ok(leaderboard) = table.ref("leaderboard")
      //check keys as player1name <> player2name and player2name <> player1name -> want to avoid duplicates
      let key1 = state.player1name <> state.player2name
      let key2 = state.player2name <> state.player1name
      let val =
        LeaderboardInformation(
          player1name: state.player1name,
          player2name: state.player2name,
          player1score: state.player1score,
          player2score: state.player2score,
        )
      case leaderboard |> table.lookup(key1) {
        [] -> {
          //check other key
          case leaderboard |> table.lookup(key2) {
            [] -> {
              //save using first key
              leaderboard
              |> table.insert([#(key1, val)])
            }
            _ -> {
              //override key
              leaderboard
              |> table.insert([#(key2, val)])
            }
          }
        }
        _ -> {
          //override key
          leaderboard
          |> table.insert([#(key1, val)])
        }
      }
      actor.Stop(process.Killed)
    }
  }
}

fn get_extra_info_dict(message: String) {
  let assert Ok(juno.Object(message_dict)) = juno.decode(message, [])
  let assert Ok(juno.String(stringified_extra_info)) =
    message_dict |> dict.get("extraInfo")

  let rect_decoder =
    dynamic.decode8(
      Rect,
      dynamic.field("x", dynamic.float),
      dynamic.field("y", dynamic.float),
      dynamic.field("width", dynamic.float),
      dynamic.field("height", dynamic.float),
      dynamic.field("top", dynamic.float),
      dynamic.field("right", dynamic.float),
      dynamic.field("bottom", dynamic.float),
      dynamic.field("left", dynamic.float),
    )

  let extra_info_decoder =
    dynamic.decode7(
      ExtraInfo,
      dynamic.field("board_coord", rect_decoder),
      dynamic.field("window_inner_height", dynamic.float),
      dynamic.field("paddle_1_coord", rect_decoder),
      dynamic.field("paddle_2_coord", rect_decoder),
      dynamic.field("paddle_common", rect_decoder),
      dynamic.field("player_1_score", dynamic.int),
      dynamic.field("player_2_score", dynamic.int),
    )

  let assert Ok(juno.Object(extra_info_dict)) =
    juno.decode(stringified_extra_info, [extra_info_decoder])

  extra_info_dict
}

fn get_juno_value_as_float(
  juno_dict: Dict(String, juno.Value(a)),
  field: String,
) {
  let assert Ok(value_of_unknown_juno_type) = juno_dict |> dict.get(field)

  let value = case
    string.inspect(value_of_unknown_juno_type) |> string.contains("Float")
  {
    True -> {
      let assert juno.Float(float_num) = value_of_unknown_juno_type
      float_num
    }
    _ -> {
      let assert juno.Int(int_num) = value_of_unknown_juno_type
      to_float(int_num)
    }
  }
}
