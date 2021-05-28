//server config
var express = require('express');
var app = express();
var http = require('http').createServer(app);
var id;

app.use(express.static(__dirname + '/public'))

app.get('/:id', (req, res) => {
    id = req.params.id

    res.sendFile(__dirname + '/public/index.html');
})
    

const port = 8028;
http.listen(port, () => {
    console.log(`Listening on port ${port}`);
})