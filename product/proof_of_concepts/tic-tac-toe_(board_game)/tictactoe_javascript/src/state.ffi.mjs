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

//action takes arguments that represents the PlayerSocket
function ffi_for_all_sockets(game_code, action) {
  return try_run(function () {
    for (const playerSocket of games.get(game_code).sockets) {
      action(playerSocket.socket, playerSocket.player, playerSocket.name);
    }
    return 0;
  });
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
  ffi_for_all_sockets,
  ffi_get_json_value,
  ffi_remove_socket,
};
