#connect= require 'connect'
io = require("socket.io").listen 8000
users = {}

io.sockets.on 'connection', (socket) ->

  socket.on 'load',  (key, user_id) ->
    unless users[key]
      users[key] = {user_id: user_id}
      socket.key = key
    users[key]['id'] = socket.id #reset this value
    io.sockets.emit 'user list changed', users
    socket.broadcast.emit 'user connected', key
    
  socket.on 'disconnect', () ->
    key = socket.key
    console.log key
    return false unless key
    delete users[key]
    socket.broadcast.emit 'user disconnected', key
    socket.broadcast.emit 'user list changed', users

  socket.on 'user message',  (msg) ->
    socket.broadcast.emit 'user message', socket.key, msg

