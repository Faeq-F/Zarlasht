import app/pages/game.{game_page, instruction}
import glacier/should
import lustre/element

pub fn show_instruction_test() {
  should.equal(instruction(True) |> element.to_string, "")
}

pub fn hide_instruction_test() {
  should.equal(instruction(False) |> element.to_string, "")
}

pub fn empty_page_test() {
  should.equal(game_page("", ""), "")
}

pub fn page_1_test() {
  should.equal(game_page("Faeq", "John"), "")
}

pub fn page_2_test() {
  should.equal(game_page("Mubz", "Faeq"), "")
}

pub fn randomized_page_test() {
  should.equal(game_page(), "")
}
