// JS must be used to SET state data
//---------------------------------------------------------------------------------------
// Server State
const games = new Map();

function ffi_add_game(game_code, socket) {
  return try_run(function () {
    if (games.has(game_code)) {
      throw new Error(
        "(STATE) Error: Game already exists! Game code: " + game_code,
      );
    } else {
      games.set(
        game_code,
        new GameState([new PlayerSocket(socket, Player.Player1)]),
      );
      console.log(
        "New game created:" + game_code + "\nCurrent Games:\n" +
          [...games.keys()],
      );
      return 0;
    }
  });
}

function ffi_add_socket(socket, game_code) {
  return try_run(function () {
    if (games.has(game_code)) {
      const game_sockets = games.get(game_code).sockets;
      if (game_sockets.length < 2) {
        games.set(
          game_code,
          new GameState([
            ...game_sockets,
            new PlayerSocket(socket, Player.Player2),
          ]),
        );
        return 0;
      } else {
        throw new Error("(STATE) Error: Game already has 2 players!");
      }
    } else {
      throw new Error("(STATE) Error: Game does not exist!");
    }
  });
}

function ffi_remove_socket(game_code, player) {
  return try_run(function () {
    if (games.has(game_code)) {
      let game_sockets = games.get(game_code).sockets;
      games.set(
        game_code,
        new GameState(
          game_sockets.filter((playerSocket) => playerSocket.player !== player),
        ),
      );
      console.log("Removed the socket from game " + game_code);
      //check if none left, so can delete game
      game_sockets = games.get(game_code).sockets;
      if (game_sockets.length == 0) {
        games.delete(game_code);
        console.log(
          "Game deleted:" + game_code + "\nCurrent Games:\n" +
            [...games.keys()],
        );
        return 0;
      } else {
        //tell everyone else to reload since the game can no longer go on
        return 1;
      }
    } else if (game_code === -1) {
      console.log("The socket was not part of a game");
      return 0;
    } else {
      throw new Error("(STATE) Error: Game does not exist!");
    }
  });
}

//---------------------------------------------------------------------------------------
// Game State

//enum
const Player = Object.freeze({
  Player1: "X",
  Player2: "O",
  Neither: "Neither",
});

class PlayerSocket {
  #socket;
  #player;
  #name;

  constructor(socket, player) {
    this.#socket = socket;
    this.#player = player;
  }

  get socket() {
    return this.#socket;
  }

  get player() {
    return this.#player;
  }

  set player(player) {
    this.#player = player;
  }

  get name() {
    return this.#name;
  }

  set name(name) {
    this.#name = name;
  }
}

class GameState {
  #state = [ // player markings in boxes - left to right, top to bottom
    Player.Neither, // first box
    Player.Neither, // second box
    Player.Neither, // third box
    Player.Neither, // etc.
    Player.Neither,
    Player.Neither,
    Player.Neither,
    Player.Neither,
    Player.Neither,
  ];
  #sockets = [];
  #turn = Player.Player1;

  constructor(sockets) {
    this.#sockets = sockets;
  }

  get state() {
    return this.#state;
  }

  set state(state) {
    this.#state = state;
  }

  get sockets() {
    return this.#sockets;
  }

  set sockets(sockets) {
    this.#sockets = sockets;
  }

  get turn() {
    return this.#turn;
  }

  set turn(turn) {
    this.#turn = turn;
  }
}

function ffi_update_state(game_code, index) {
  return try_run(function () {
    games.get(game_code).state[index] = games.get(game_code).turn;
    games.get(game_code).turn = games.get(game_code).turn == Player.Player1
      ? Player.Player2
      : Player.Player1;
    return 0;
  });
}

//action takes arguments that represents the PlayerSocket
function ffi_for_all_sockets(game_code, action) {
  return try_run(function () {
    for (const playerSocket of games.get(game_code).sockets) {
      action(playerSocket.socket, playerSocket.player, playerSocket.name);
    }
    return 0;
  });
}

function ffi_set_player_name(game_code, socket, name) {
  let names_set = 0;
  for (const playerSocket of games.get(game_code).sockets) {
    if (playerSocket.socket == socket) {
      playerSocket.name = name;
    }
    if (playerSocket.name != undefined) {
      names_set++;
    }
  }
  if (names_set === 2) {
    return 0;
  } else {
    return -1;
  }
}

function ffi_get_turn(game_code) {
  return games.get(game_code).turn;
}

function ffi_get_player_from_game_state(game_code, index) {
  return games.get(game_code).state[index];
}

function ffi_get_winning_player(game_code) {
  const boxes = games.get(game_code).state;
  //possible combinations of boxes marked to be a winner
  const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  //for each combination
  for (let i = 0; i < lines.length; i++) {
    const [a, b, c] = lines[i]; // 3 boxes required to be marked
    const player = boxes[a]; // if the same player is in all boxes
    if (player == Player.Player1 || player == Player.Player2) {
      if (player === boxes[b] && player === boxes[c]) {
        console.log(player + " has won game " + game_code);
        return player; // they won
      }
    }
  }
  for (const box of boxes) if (box == Player.Neither) return Player.Neither;
  console.log("game " + game_code + " is a draw");
  return "Draw";
}

//---------------------------------------------------------------------------------------
// State helper functions

/**
 * @param {function} func The function to try to run
 *
 * @returns {int} The error code from func. 0 if the function runs successfully, otherwise -1
 */
function try_run(func) {
  try {
    return func();
  } catch (exception) {
    console.log(exception);
    return -1;
  }
}

function ffi_get_json_value(json_string, key) {
  const val = JSON.parse(json_string)[key] + "";
  if (val === "[object Object]") {
    return JSON.stringify(JSON.parse(json_string)[key]);
  } else {
    return val;
  }
}

export {
  ffi_add_game,
  ffi_add_socket,
  ffi_for_all_sockets,
  ffi_get_json_value,
  ffi_get_player_from_game_state,
  ffi_get_turn,
  ffi_get_winning_player,
  ffi_remove_socket,
  ffi_set_player_name,
  ffi_update_state,
};
