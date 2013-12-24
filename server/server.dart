import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Client {
  int id; // the client connection id
  Server srv; // the server hosting this client
  WebSocket conn; // the websocket connection to the client
  
  Client(this.id,this.srv,this.conn) {
    conn.listen(onData, onDone: close); // currently they all go to the same function
  }
  
  void onData(msg) {
    
  }
  
  void close() { // close this client's connection
    print("Client id:$id disconnected.");
    srv.clients.remove(id); // remove the client from the list of connections
  }
}

class GameServer {
  // This class should handle the server stage and everything in the world
  
  Server srv; // The main server
  
  bool up = false; // is the game server up?
  
  GameServer(this.srv);
  
  void start() { // start the game server
    if (up) return; // the server is already running
    print('Starting game server');
    up = true;
    new Timer(new Duration(milliseconds:100), loop); // begin the game loop
  }
  void stop() { // stop the game server
    if (!up) return; // server is already stopped
    print('Stopping game server');
    up = false;
  }
  
  void loop() { // the main game server loop
    if (!up) return; // the server has stopped
    
    new Timer(new Duration(milliseconds:100), loop); // continue looping
  }
}

class Server {
  // The main server class, handles all connections but no specific actions

  int token = 0; // token counter for giving client ids - should be replaced with something more secure
  Map<int,Client> clients = {}; // connected clients
  GameServer gserver; // The main game server
  
  Server(String ip, int port) {
    gserver = new GameServer(this);
    gserver.start();
    HttpServer.bind(ip, port) // bind to the given ip and port
    .then((HttpServer server) {
      print('Listening for connections on 127.0.0.1:8080');
      server.listen((HttpRequest request) { // begin listening for httprequests
        WebSocketTransformer.upgrade(request).then((WebSocket ws) {
          print("New client, id:$token");
          clients[token] = new Client(token,this,ws); // create a new client to manage the connection
          token++;
        });
      });
    });
  }
  
  // send a message to all clients connected to the server
  void send(data) {
    var msg = JSON.encode(data);
    clients.forEach((k,v) {
      v.conn.add(msg);
    });
  }
}


void main() {
  var server = new Server('127.0.0.1',8080);
}