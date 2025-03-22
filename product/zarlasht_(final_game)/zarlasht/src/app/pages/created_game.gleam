import app/actors/actor_types.{
  type CustomWebsocketMessage, type GameActorMessage, type GameActorState,
  type Player, type PlayerSocket, GameActorState, UpdateState,
}
import app/pages/components/bottom_bar.{bottom_bar}
import app/pages/components/lucide_lustre.{copy}
import gleam/erlang/process.{type Subject}
import gleam/int.{to_string}
import gleam/list
import gleam/string.{join}
import lustre/attribute.{attribute, class, id, name, style, type_, value}
import lustre/element.{type Element}
import lustre/element/html.{
  button, div, form, input, label, li, p, script, text, ul,
}

pub fn created_game_page(
  state: GameActorState,
  game_subject: Subject(GameActorMessage),
) {
  div([id("page"), class("h-full w-full")], [
    div(
      [
        class("!text-left !absolute !z-[999]"),
        style([
          #("width", "calc(100% - 2rem)"),
          #("height", "calc(100% - 2rem)"),
        ]),
      ],
      [
        div([class("!w-full")], [
          bottom_bar(info(), buttons(state.code)),
          p([class(" !text-7xl text-center !mt-4 !text-teal-500 font-header")], [
            text(state.code |> to_string),
          ]),
          p([class("!text-2xl text-center font-subheader")], [
            text("Share this code with friends!"),
          ]),
          div([class("game-container"), style([#("cursor", "grab")])], [
            player_container(state, game_subject),
          ]),
          script([], page_script()),
        ]),
      ],
    ),
  ])
  |> element.to_string
}

pub fn player_container(
  state: GameActorState,
  game_subject: Subject(GameActorMessage),
) {
  ul([class("!grid justify-center"), id("player-container")], [
    form([class("row")], generate_players(state)),
    form(
      [
        attribute("hx-trigger", "end"),
        attribute("ws-send", ""),
        id("colors"),
        class("sortable  !row"),
      ],
      generate_colors(state, game_subject),
    ),
  ])
}

fn generate_players(state: GameActorState) {
  let items =
    state.participants
    |> list.map(fn(player) {
      li([class("item text-center font-subheader")], [text({ player.0 }.name)])
    })

  case items |> list.length() >= 5 {
    True -> items
    _ -> {
      items
      |> list.append(list.repeat(
        li([class("item text-center font-subheader")], [
          text("Waiting for player to join..."),
        ]),
        5 - { items |> list.length() },
      ))
    }
  }
}

fn generate_colors(
  state: GameActorState,
  game_subject: Subject(GameActorMessage),
) {
  let items =
    state.participants
    |> list.map(fn(player) {
      div([class("bg-" <> { player.0 }.color <> "-500/20")], [
        input([value({ player.0 }.color), name("colors"), type_("hidden")]),
      ])
    })

  case items |> list.length() >= 5 {
    True -> items
    _ -> {
      items
      |> list.append(
        [1, 2, 3, 4, 5]
        |> list.drop_while(fn(num) { num <= items |> list.length() })
        |> list.map(fn(num) {
          let color =
            state.colors
            |> list.index_map(fn(color, i) { #(i, color) })
            |> list.find(fn(color) { color.0 == num - 1 })
          #(num, color)
        })
        |> list.map(fn(x) {
          let color = get_color(x.0, state, game_subject)
          div([class("bg-" <> color <> "-500/20")], [
            input([value(color), name("colors"), type_("hidden")]),
          ])
        }),
      )
    }
  }
}

/// Designed to get tailwind background  colors (e.g., "bg-red-500/20") to help identify players in the game
///
/// Colors will be random. If there are more players than colors, colors will repeat
///
/// Colors are stored in the game state, which is updated by this function
///
pub fn get_color(
  player_num: Int,
  state: GameActorState,
  game_subject: Subject(GameActorMessage),
) {
  case player_num < 6 {
    True -> {
      //use default colors (minimum 5 player)
      let assert Ok(color_grabbed) =
        state.used_colors
        |> list.index_map(fn(color, i) { #(i, color) })
        |> list.find(fn(color) { color.0 == player_num - 1 })
      color_grabbed.1
    }
    False -> {
      //check if the player already has a color
      case
        {
          state.used_colors
          |> list.index_map(fn(color, i) { #(i, color) })
          |> list.find(fn(color) { color.0 == player_num - 1 })
        }
      {
        Ok(color_grabbed) -> color_grabbed.1
        _ -> {
          //check if need to reuse colors
          let colors = case state.colors |> list.is_empty {
            True -> state.used_colors
            _ -> state.colors
          }
          let used_colors = case state.colors |> list.is_empty {
            True -> []
            _ -> state.used_colors
          }
          //get color
          let assert Ok(color_grabbed) =
            colors |> list.shuffle() |> list.first()
          //update state
          let colors =
            colors |> list.filter(fn(color) { color != color_grabbed })
          let used_colors = used_colors |> list.append([color_grabbed])
          process.send(
            game_subject,
            UpdateState(
              GameActorState(..state, colors: colors, used_colors: used_colors),
            ),
          )
          color_grabbed
        }
      }
    }
  }
}

fn info() {
  div(
    [
      id("created_game_info"),
      class("btn !bg-gray-100 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("minimum of 5 players")],
  )
}

pub fn info_error_player_count() {
  div(
    [
      id("created_game_info"),
      class("btn !bg-gray-100 !text-red-500 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("You need a minimum of 5 players!")],
  )
}

pub fn info_error_setting_name() {
  div(
    [
      id("created_game_info"),
      class("btn !bg-gray-100 !text-red-500 font-text !text-lg"),
      style([#("cursor", "default")]),
    ],
    [text("A player is still setting their name!")],
  )
}

fn buttons(game_code) {
  [
    div([class("popover popover-border contents")], [
      label(
        [
          class(join(
            [
              "popover-trigger btn border !rounded-r-none !rounded-full",
              "bg-black/15 hover:bg-black/30",
              "dark:bg-white/20  dark:hover:bg-white/40 dark:border-white/40",
              "border-black/40 text-current", "transition-all duration-500",
            ],
            " ",
          )),
          attribute("tabindex", "0"),
          attribute(
            "@click",
            "navigator.clipboard.writeText(\""
              <> int.to_string(game_code)
              <> "\")",
          ),
        ],
        [copy([])],
      ),
      div(
        [
          class(
            "popover-content w-32 popover-top-left !fixed font-text !bg-green-300",
          ),
          attribute("tabindex", "0"),
          style([#("width", "fit-content")]),
        ],
        //TODO
        [div([], [text("Copied game code")])],
      ),
    ]),
    button(
      [
        attribute("ws-send", ""),
        id("start_game"),
        class(join(["btn !rounded-r-full font-text !text-xl"], " ")),
      ],
      [text("Start Game")],
    ),
  ]
}

fn page_script() {
  let drag_scroll =
    "
    let mouseDown = false;
    let startX, scrollLeft;
    const slider = document.querySelector('.game-container');

    const startDragging = (e) => {
      mouseDown = true;
      startX = e.pageX - slider.offsetLeft;
      scrollLeft = slider.scrollLeft;
    }

    const stopDragging = (e) => {
      mouseDown = false;
    }

    const move = (e) => {
      e.preventDefault();
      if(!mouseDown) { return; }
      const x = e.pageX - slider.offsetLeft;
      const scroll = x - startX;
      slider.scrollLeft = scrollLeft - scroll;
    }

    // Add the event listeners
    slider.addEventListener('mousemove', move, false);
    slider.addEventListener('mousedown', startDragging, false);
    slider.addEventListener('mouseup', stopDragging, false);
    slider.addEventListener('mouseleave', stopDragging, false);
    "

  let sortable_colors =
    "
    htmx.onLoad(function (content) {
    var sortables = content.querySelectorAll(\".sortable\");
    for (var i = 0; i < sortables.length; i++) {
      var sortable = sortables[i];
      var sortableInstance = new Sortable(sortable, {
        animation: 150,
        axis: 'horizontal',
        ghostClass: 'blue-background-class',

        // Make the `.htmx-indicator` unsortable
        filter: \".htmx-indicator\",
        onMove: function (evt) {
          return evt.related.className.indexOf('htmx-indicator') === -1;
        },
      });

      // Re-enable sorting on the `htmx:afterSwap` event
      sortable.addEventListener(\"htmx:afterSwap\", function () {
        sortableInstance.option(\"disabled\", false);
      });
    }
    })
    "
  drag_scroll <> sortable_colors
}
