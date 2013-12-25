import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() {
  new Server('127.0.0.1',8080).start(); // start the main server
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
  
  void start() {
    if (up) return; // The server is already running
    print("Starting game server.");
    new Timer(new Duration(milliseconds:interval), loop);
    up = true;
  }
  void stop() {
    if (!up) return; // The server is already stopped
    print("Stopping game server.");
    up = false;
  }
  
  void send(data) { // Send msg to all clients
    for (Client client in clients.values) { // some modifcation while looping issues here
      client.send(data);
    }
  }
  
  void addClient(WebSocket ws) { // Add a new client to the game server
    clients[ws.hashCode] = new Client(ws,this); // create a new client
  }
  void removeClient(Client client) { // Remove a client from the game server
    clients.remove(client.ws.hashCode); // Remove the client from the connected clients
  }
  
  void loop() {
    // Start the loop again, to get real time keep a record of lastLoop
    new Timer(new Duration(milliseconds:interval), loop);
  }
}

class Client {
  // Manages a single client's connection
  GameServer gsrv; // The game server the client is connected to
  WebSocket ws; // the websocket connection with the server
  
  Client(this.ws,this.gsrv) {
    ws.listen(receive, onDone: close);
  }
  
  void send(data) { // Send message only to this client
    ws.add(JSON.encode(data));
  }
  
  void receive(msg) { // recieve a message from the client
    
  }
  
  void close() { // close this client's connection
    print('Client [${ws.hashCode}] disconnected');
    gsrv.removeClient(this); // remove the client from the 
  }
}