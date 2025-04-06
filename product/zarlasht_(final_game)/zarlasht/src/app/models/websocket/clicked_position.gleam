import app/actors/actor_types.{
  type WebsocketActorState, Ambush, Battle, Cemetary, Demon, EnemyTribe, Move,
  Player, PlayerMoved, Ravine, WebsocketActorState,
}
import app/pages/map.{map_grid}
import gleam/erlang/process
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn clicked_position(position: String, state: WebsocketActorState) {
  let assert Some(game_subject) = state.game_subject
  //parse position
  let assert Ok(x) = position |> string.split("_") |> list.first()
  let assert Ok(y) = position |> string.split("_") |> list.last()
  let assert Ok(x) = int.parse(x)
  let assert Ok(y) = int.parse(y)
  //check if we should enter battle
  let assert Ok(Some(action)) =
    list.index_map(map_grid(), fn(z, row) {
      list.index_map(z, fn(cell, column) {
        case column == x && row == y {
          True -> {
            //randomize battle based off cell type
            Some(case cell {
              //TODO - randomy generate warrior types
              // 4 = red = enemy tribe - always battle (warrior)
              4 -> Battle(EnemyTribe("Expert Swordsman"), 0, 0, 0)
              // 5 = cyan = cemetary - 30% chance (undead)
              5 ->
                case int.random(10) {
                  num if num < 3 -> Battle(Cemetary, 0, 0, 0)
                  _ -> Move(0)
                }
              // 6 = teal = ritual - always battle (demon)
              6 -> Battle(Demon, 0, 0, 0)
              // 7 = violet = ravine - 70%
              7 ->
                case int.random(10) {
                  num if num < 7 -> Battle(Ravine("Expert Swordsman"), 0, 0, 0)
                  _ -> Move(0)
                }
              // 8 = lime = fog - depends on who nearby - TODO
              8 -> Move(0)
              // 9 = sky = ambush - always battle
              9 -> Battle(Ambush("Expert Swordsman"), 0, 0, 0)
              // 0 = white = mountain - no battle (can't be here)
              // 1 = amber = path - no battle
              // 2 = emerald = beginning - no battle
              // 3 = pink = end - no battle
              _ -> Move(0)
            })
          }
          _ -> None
        }
      })
    })
    |> list.flatten
    |> list.find(option.is_some)
  //update game state
  let player =
    Player(
      ..state.player,
      action: action,
      position: #(x, y),
      old_positions: state.player.old_positions
        |> list.append([state.player.position]),
    )
  process.send(game_subject, PlayerMoved(player, game_subject))
  //update overall state, including move action
  WebsocketActorState(..state, player: player)
}
