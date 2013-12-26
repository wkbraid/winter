// file: stage.dart
library stage;

import 'dart:html';

import '../common.dart';
import 'util/utils.dart';

part 'stage/hero.dart';

class Stage {
  // Handles the client interpretation of the map, including the hero
  Viewport view; // The main game viewport
  Hero hero; // The current hero
  
  GameMap map = new GameMap([[]]); // The map we are currently on
  
  var send; // Send function passed in from the main game object
  
  Stage(Character char,this.view,this.send) {
    hero = new Hero(char); // Load the character data into the hero
  }
  
  void receive(data) { // receive data from the server, passed from the game
    if (data["cmd"] == "update") { // update from server
      map.unpack(data["map"]);
    }
  }
  void update(num dt) { // update the stage's contents
    hero.update(dt);
    map.update(dt); // try to predict actions on the server
    
    send({"cmd":"update","hero":hero.pack()});
  }
  
  void draw() { // draw the stage to the screen
    view.clear(); // Clear the screen
    view.drawGameMap(map); // Draw the map
  }
}