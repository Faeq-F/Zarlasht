//// User actions when playing the game

import app/actors/actor_types.{
  type GameActorState, DownHit, EnterHit, ExtraInfo, GameActorState, Leaderboard,
  Play, Rect, SHit, SendToClient, Start, UpHit, WHit,
}
import app/pages/game.{inject_js, instruction}
import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/erlang/process
import gleam/float
import gleam/int.{parse, to_float}
import gleam/option.{Some}
import gleam/otp/actor
import gleam/string
import juno
import lustre/attribute
import lustre/element
import lustre/element/html
import mist

/// the game actor's action when the enter key is hit
///
pub fn enter_hit(message: String, state: GameActorState) {
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

/// the game actor's action when the w key is hit
///
pub fn w_hit(message: String, state: GameActorState) {
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

/// the game actor's action when the s key is hit
///
pub fn s_hit(message: String, state: GameActorState) {
  let extra_info_dict = get_extra_info_dict(message)

  let assert Ok(juno.Object(board_coord_dict)) =
    extra_info_dict |> dict.get("board_coord")
  let board_coord_bottom = get_juno_value_as_float(board_coord_dict, "bottom")

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

/// the game actor's action when the up key is hit
///
pub fn up_hit(message: String, state: GameActorState) {
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

/// the game actor's action when the down key is hit
///
pub fn down_hit(message: String, state: GameActorState) {
  let extra_info_dict = get_extra_info_dict(message)

  let assert Ok(juno.Object(board_coord_dict)) =
    extra_info_dict |> dict.get("board_coord")
  let board_coord_bottom = get_juno_value_as_float(board_coord_dict, "bottom")

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

///Decodes the websocket message to get the dictionary representing the extra_info dict that gets appended when the user is playing the game
///
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

/// Gets a Int or Float value from a dict, as a Float
///
/// Used when you do not know the type the decoded dict has it saved as
///
fn get_juno_value_as_float(
  juno_dict: Dict(String, juno.Value(a)),
  field: String,
) {
  let assert Ok(value_of_unknown_juno_type) = juno_dict |> dict.get(field)

  case string.inspect(value_of_unknown_juno_type) |> string.contains("Float") {
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

/// Called when the user hits the enter key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_enter(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, EnterHit(message))
}

/// Called when the user hits the W key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_w(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, WHit(message))
}

/// Called when the user hits the S key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_s(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, SHit(message))
}

/// Called when the user hits the up_arrow key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_up(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, UpHit(message))
}

/// Called when the user hits the down_arrow key while playing the game
///
/// Lets the Game actor know so that the action can be handled
///
pub fn on_down(player: actor_types.PlayerSocket, message: String) {
  let assert Some(game_subject) = player.state.game_subject
  process.send(game_subject, DownHit(message))
}

/// Called when the user hits the trophy button
///
/// Lets the director actor know so that it can assemble and display it to the user
///
pub fn show_leaderboard(player: actor_types.PlayerSocket) {
  process.send(
    player.state.director_subject,
    Leaderboard(player.state.ws_subject),
  )
  player.state
}

/// Called when the user hits the cross when viewing the leaderboard overlay
///
/// closes the overlay
///
pub fn close_leaderboard(player: actor_types.PlayerSocket) {
  let assert Ok(_) = mist.send_text_frame(player.socket, empty_leaderboard())
  player.state
}

///The overlay div, emptied, so that the user is no longer looking at the leaderboard
///
fn empty_leaderboard() {
  html.div([attribute.id("overlay")], []) |> element.to_string
}
