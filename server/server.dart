// file: server.dart
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../common.dart';
import 'db.dart' as db;

void main() {
  new Server('0.0.0.0',23193).start(); // start the main server
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
    // update the maps
    var tmp = maps.keys.toList();
    for (String mapid in tmp) {
      maps[mapid].update(interval);
    }
    
    tmp = clients.values.toList(); // take a copy for concurrency
    for (Client client in tmp) { // update all the clients
      client.update();
    }
    // Start the loop again, to get real time keep a record of lastLoop
    new Timer(new Duration(milliseconds:interval), loop);
  }
}

class Client {
  // Manages a single client's connection
  bool loggedin = false; // is the client logged in
  
  GameServer gsrv; // The game server the client is connected to
  WebSocket ws; // the websocket connection with the server
  
  Account acc; // The logged in account
  GameMap map; // The game map the hero is currently on
  
  Client(this.ws,this.gsrv) {
    print('Client [${ws.hashCode}] connected');
    ws.listen(receive, onDone: close); // start listening
  }
  
  void login(data) {
    if (loggedin) return; // need to be logged out to login
    acc = db.accs[data["user"]]; // try to fetch the account from the db
    if (acc != null) { // we have an account
      if (!gsrv.maps.containsKey(acc.hero.mapid)) // chech that the map is loaded
        gsrv.maps[acc.hero.mapid] = db.maps[acc.hero.mapid]; // if not load the map
      
      // add the hero to the map
      map = gsrv.maps[acc.hero.mapid];
      acc.hero.map = map;
      map.addHero(acc.hero);
      
      // TODO should send more detailed information than hero.pack() provides to client
      send({"cmd":"login","success":true,"hero":acc.hero.pack()});
      loggedin = true; // start sending updates to the client
    } else { // The login failed
      send({"cmd":"login","success":false});
    }
  }
  void logout() {
    loggedin = false;
    acc = null; // Remove account data
  }
  
  void input(data) { // handle user input from the client
    acc.hero.input = data; // Update the hero's latest input information
  }
  
  void update() { // Send updates to the client
    if (!loggedin) return;
    if (map.id != acc.hero.mapid) { // the hero's map has changed
      map.removeHero(acc.hero);
      if (!gsrv.maps.containsKey(acc.hero.mapid)) // chech that the map is loaded
        gsrv.maps[acc.hero.mapid] = db.maps[acc.hero.mapid]; // if not load the map
      map = gsrv.maps[acc.hero.mapid];
      map.addHero(acc.hero);
    }
    send({"cmd":"update",
      "map": map.pack(),
      "hero" : acc.hero.packRest()
    });
  }
  
  void receive(msg) { // recieve a message from the client
    var data = JSON.decode(msg);
    if (data["cmd"] == "login")
      login(data); // attempt to login the client
    else if (data["cmd"] == "logout")
      logout();
    else if (data["cmd"] == "input") {
      input(data);
    }
  }
  
  void send(data) { // Send message only to this client
    ws.add(JSON.encode(data));
  }
  
  void close() { // close this client's connection
    // TODO: Save character information to the fake database...
    // TODO: Get a real database...
    if (loggedin)
      map.removeHero(acc.hero); // Remove the hero from the map
    print('Client [${ws.hashCode}] disconnected');
    gsrv.removeClient(this); // remove the client from the connected clients
  }
}