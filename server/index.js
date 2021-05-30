//server config
var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http);
var players = {};
var id;

app.use(express.static(__dirname + '/public'))

app.get('/:id', (req, res) => {
    id = req.params.id

    res.sendFile(__dirname + '/public/index.html');
})
    
//sockets
io.on("connect", (socket) => {
    console.log(`User connected with id: ${socket.id}!`);
    players[socket.id] = {
        pos: {
            x: 0,
            y: 0
        },
    }
})

const port = 8028;
http.listen(port, () => {
    console.log(`Listening on port ${port}`);
})