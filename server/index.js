const { exec } = require('child_process'); //exec function is used to execute scripts

// server initialization
const express = require('express');
const app = express();
const http = require('http').createServer(app);
const port = 3123; // server port

// setup file to be sent on connection
const filePath = "/public" // do not add '/' at the end
const fileName = "index.html"

// socket inicialization
const io = require('socket.io')(http);

// players will store all connected players
const players = {};
// games is the variable containing all games in games.json with their names and executable scripts
const games = require('./games.json')

// currentGame is responsible for storing the last game that was opened
var currentGame = ''
var id;


app.use(express.static(__dirname + filePath))

app.get('/:id', (req, res) => {
    // store screen id
    id = req.params.id

    res.sendFile(__dirname + `${filePath}/${fileName}`);
})

//sockets
io.on("connect", (socket) => {
    console.log(`User connected with id: ${socket.id}!`);

    // add player to players object
    players[socket.id] = {
        pos: {
            x: 0,
            y: 0
        },
    }

    /**
     * Update players position
     * @param {number} dir direction that the player is going (up, down, left right)
     */
    socket.on("update-player", function (dir) {
        console.log(`Update player[${socket.id}]:`, dir);
    })

    /**
     * Open the game based on gameName
     * @param {String} gameName game name to execute open script (must be the same as the one in games.json -> eg. "pacman", "pong")
     */
    socket.on("open-game", function (gameName) {
        // save the  current game name
        currentGame = gameName
        console.log("Opening game:", gameName);
        console.log(`execute: bash ${games[gameName].openScript}`)
        
        // execute the open game script
        exec(`bash ${games[gameName].openScript}`)
    })

    /**
     * Close the game based on gameName
     */
    socket.on("close-game", function () {
        console.log("Closing game: ", currentGame)
        console.log(`execute: bash ${games[currentGame].closeScript}`)
        exec(`bash ${games[currentGame].closeScript}`)
    })

    /**
     * Remove player from player object on disconnect
     */
    socket.on("disconnect", function () {
        console.log(`User with id ${socket.id} disconnected!`);

        delete players[socket.id];
    })
})

// start server in defined port
http.listen(port, () => {
    console.log(`Listening on port ${port}`);
})