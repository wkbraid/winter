// file: server.dart

library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../common.dart';
import 'db.dart' as db;

part 'gameserver.dart';
part 'convhandler.dart';

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
          //print('Accepting request from ${request.connectionInfo.remoteAddress}');
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