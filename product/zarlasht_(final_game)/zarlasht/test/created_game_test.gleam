import app/pages/created_game.{info_error_player_count, info_error_setting_name}
import glacier/should
import lustre/element

pub fn error_player_count_test() {
  info_error_player_count()
  |> element.to_string
  |> should.equal(
    "<div id=\"created_game_info\" class=\"btn !bg-gray-100 !text-red-500 font-text !text-lg\" style=\"cursor:default;\">You need a minimum of 5 players!</div>",
  )
}

pub fn error_setting_name_test() {
  info_error_setting_name()
  |> element.to_string
  |> should.equal(
    "<div id=\"created_game_info\" class=\"btn !bg-gray-100 !text-red-500 font-text !text-lg\" style=\"cursor:default;\">A player is still setting their name!</div>",
  )
}
