var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){

  console.log("user: " + socket.id + " is connect");

  socket.on('chat message', function(msg){
    console.log("user: " + socket.id + " has sent you message: " + msg);
    io.emit('chat message', msg);
  });

});

io.on("disconnect", function(socket) {
  console.log("user: " + socket.id + " is disconnect");
});

http.listen(3000, function(){
  console.log('listening on localhost:3000');
});
