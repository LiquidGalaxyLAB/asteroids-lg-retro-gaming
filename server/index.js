const { exec } = require("child_process"); //exec function is used to execute scripts

// server initialization
const express = require("express");
const app = express();
const http = require("http").createServer(app);
const port = 3123; // server port

// setup file to be sent on connection
const filePath = "/public"; // do not add '/' at the end
const fileName = "index.html";

// socket inicialization
const io = require("socket.io")(http);

// games is the variable containing all games in games.json with their names and executable scripts
const games = require("./games.json");

// currentGame is responsible for storing the last game that was opened
let currentGame = "";

app.use(express.static(__dirname + filePath));

app.get("/", (req, res) => {
  res.sendFile(__dirname + `${filePath}/${fileName}`);
});

// sockets functions and event listeners
io.on("connect", (socket) => {
  console.log(`User connected with id: ${socket.id}!`);

  /**
   * Update players position
   * @param {number} dir direction that the player is going (up, down, left right)
   */
  function updatePlayer(dir) {
    console.log(`Update player[${socket.id}]:`, dir);
  }
  socket.on("update-player", updatePlayer);

  /**
   * Open the game based on gameName
   * @param {String} gameName game name to execute open script (must be the same as the one in games.json -> eg. "pacman", "pong")
   */
  function openGame(gameName) {
    // save the  current game name
    currentGame = gameName;
    console.log("Opening game:", gameName);
    console.log(`execute: bash ${games[gameName].openScript}`);

    // execute the open game script
    exec(`bash ${games[gameName].openScript} lq`, (err) => {
      if (err) {
        console.error(`Error executing ${games[gameName].openScript}`);
        console.error(err);
      }
    });
  }
  socket.on("open-game", openGame);

  /**
   * Close the game based on currentGame variable (set when game is opened)
   */
  function closeGame() {
    try {
      console.log("Closing game: ", currentGame);
      console.log(`execute: bash ${games[currentGame].closeScript}`);
      exec(`bash ${games[currentGame].closeScript}`, (err) => {
        if (err) {
          console.error(`Error executing ${games[currentGame].closeScript}`);
          console.error(err);
        }
      });
    } catch (err) {
      console.log("Error closing game");
      console.error(err);
    }
  }
  socket.on("close-game", closeGame);

  /**
   *  Disconnect method -> log when user disconnected
   */
  function onDisconnect() {
    console.log(`User with id ${socket.id} disconnected!`);
  }
  socket.on("disconnect", onDisconnect);
});

// start server in defined port
http.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
