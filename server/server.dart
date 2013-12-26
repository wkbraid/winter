// file: server.dart
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../common.dart';
import 'db.dart' as db;

void main() {
  new Server('127.0.0.1',23193).start(); // start the main server
}

class Server {
  // The main server class, manages connections between client and server
  GameServer gsrv; // The main game server
  bool up = false; // is the server running?
  String ip; int port; // connection information
  
  Server(this.ip, this.port);
  
  void start() {
    if (up) return; // The server is already running
    print("Starting main server.");
    gsrv = new GameServer();
    gsrv.start();
    HttpServer.bind(ip,port) // bind the server to the ipadress
    .then((HttpServer server) {
      print('Listening for connections on $ip:$port');
      server.listen((HttpRequest request) { // begin listening for connections
        WebSocketTransformer.upgrade(request).then((WebSocket ws) {
          // We have a new connection!
          print('Accepting request from ${request.connectionInfo.remoteAddress}');
          gsrv.addClient(ws);
        });
      });
    });
    up = true;
  }
  void stop() {
    if (!up) return; // The server is already stopped
    print("Stopping main server.");
    up = false;
  }
}

class GameServer {
  // The game server, manages the world and everything in it
  Map<int,Client> clients = {}; // connected clients
  bool up = false; // is the server running?
  
  int interval = 20; // Loop interval in milliseconds
  
  Map<String, GameMap> maps = {}; // The game maps
  
  void start() {
    if (up) return; // The server is already running
    print("Starting game server.");
    new Timer(new Duration(milliseconds:interval), loop); // start the main loop
    up = true;
  }
  void stop() {
    if (!up) return; // The server is already stopped
    print("Stopping game server.");
    up = false;
  }
  
  void send(data) { // Send msg to all clients
    var tmp = clients.values.toList(); // prevent concurrency issues by making a copy
    for (Client client in tmp) { // some modifcation while looping issues here
      client.send(data);
    }
  }
  
  void addClient(WebSocket ws) { // Add a new client to the game server
    clients[ws.hashCode] = new Client(ws,this); // create a new client
  }
  void removeClient(Client client) { // Remove a client from the game server
    clients.remove(client.ws.hashCode); // Remove the client from the connected clients
  }
  
  void loop() { // the main game loop
    var tmpmapkeys = maps.keys.toList();
    for (String id in tmpmapkeys)
      maps[id].players = {}; // Clear the map of players
    
    var tmp = clients.values.toList(); // copy to avoid concurrency issues
    tmp.removeWhere((client) => client.player == null); // only take logged in players
    for (Client client in tmp) { // Add each player to the correct map
      maps[client.acc.char.mapid].players[client.acc.user] = client.player;
    }
    for (Client client in tmp) { // Ask each client to update
      client.update();
    }

    // Start the loop again, to get real time keep a record of lastLoop
    new Timer(new Duration(milliseconds:interval), loop);
  }
}

class Client {
  // Manages a single client's connection
  GameServer gsrv; // The game server the client is connected to
  WebSocket ws; // the websocket connection with the server
  
  Account acc; // The logged in account
  Player player; // The physical embodiment of the character currently playing
  
  Client(this.ws,this.gsrv) {
    print('Client [${ws.hashCode}] connected');
    ws.listen(receive, onDone: close);
  }
  
  void update() { // Send updates to the client
    send({"cmd": "update", "map": gsrv.maps[acc.char.mapid].pack()});
  }
  
  void send(data) { // Send message only to this client
    ws.add(JSON.encode(data));
  }
  
  void receive(msg) { // recieve a message from the client
    var data = JSON.decode(msg);
    if (data["cmd"] == "login") {
      acc = db.accs[data["user"]];
      if (acc != null) { // we have an account
        if (!gsrv.maps.containsKey(acc.char.mapid)) // check that the map is loaded
          gsrv.maps[acc.char.mapid] = db.maps[acc.char.mapid];
        send({"cmd":"login","success":true, "acc": acc.pack()});
        player = new Player.fromChar(acc.char); // maybe this should be done as an unpack from the hero instead
      } else { // invalid login
        send({"cmd":"login","success":false});
      }
    } else if (data["cmd"] == "update") {
      acc.char.unpack(data["hero"]["char"]); // update the character
      player.unpack(data["hero"]["player"]); // update the player
    }
  }
  
  void close() { // close this client's connection
    print('Client [${ws.hashCode}] disconnected');
    gsrv.removeClient(this); // remove the client from the 
  }
}