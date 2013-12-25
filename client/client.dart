// file: client.dart
import 'dart:html';
import 'dart:convert';
import 'dart:async';

import '../common/common.dart';
import 'util/viewport.dart';

void main() {
  var g = new Game()..connect('127.0.0.1',8080);
}

class Game {
  // The main game object, establishes a connection with the server and mediates between the stage and the gui
  bool connected = false; // Is the game connected to the server
  WebSocket ws; // the websocket connection with the server
  
  int interval = 10; // the loop interval in milliseconds
  
  Account acc; // the currently logged in account
  Viewport view;
  Stage stage;
  Gui gui;
  
  void begin() { // We have successfully logged in, begin the game
    view = new Viewport(querySelector("#area"));
    new Timer(new Duration(milliseconds:interval),loop); // start the main game loop
  }
  
  void loop() { // the main game loop
    // for now do nothing, later predict server decisions
    new Timer(new Duration(milliseconds:interval),loop); // start the loop again
  }
  
  
  void start(e) { // We are connected, start the game (should not be called directly)
    if (!connected) return; // game must be connected to the server to start
    print("Connected. Logging in");
    send({"cmd":"login","user":"knarr"}); // ask the server to log in
  }
  void stop(e) { // The connection is closed, stop the game
    if (connected) return; // stop should not be called directly, use disconnect instead
    print("Connection Closed");
  }
  
  void send(data) { // send data to the server
    ws.send(JSON.encode(data));
  }
  void receive(e) { // data received from the server
    var data = JSON.decode(e.data);
    //print("Receieved: $data");
    if (data["cmd"] == "login") {
      if (data["success"]) { // we successfully logged in
        print("Successfully logged in");
        acc = new Account.fromPack(data["acc"]);
        begin(); // begin the game
      } else // treat all errors like invalid usernames for now
        print("Invalid username");
    }
  }
  
  void connect(ip, port) {
    if (connected) disconnect(); // reconnect with the new ip/port
    print("Connecting to server");
    ws = new WebSocket('ws://$ip:$port');
    ws.onOpen.listen(start, onError:(e) {
      print("Failed to connect to server");
    });
    ws.onClose.listen(stop);
    ws.onMessage.listen(receive);
    connected = true;
  }
  void disconnect() {
    ws.close();
    connected = false;
  }
}