import 'dart:html';
import 'dart:convert';
import 'dart:async';

void main() {
  var g = new Game()..connect('127.0.0.1',8080);
  
  new Timer(new Duration(seconds:3), g.disconnect);
}

class Game {
  bool connected = false; // Is the game connected to the server
  WebSocket ws; // the websocket connection with the server
  
  void start(e) { // We are connected, start the game (should not be called directly)
    if (!connected) return; // game must be connected to the server to start
    print("Connected");
  }
  void stop(e) { // The connection is closed, stop the game
    if (connected) return; // stop should not be called directly, use disconnect instead
    print("Connection Closed");
  }
  
  void send(data) {
    ws.send(JSON.encode(data));
  }
  void receive(e) {
    var data = JSON.decode(e.data);
    print("Receieved: $data");
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