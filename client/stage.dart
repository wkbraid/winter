// file: stage.dart
library stage;

import 'dart:html';

import '../common.dart';
import 'util/utils.dart';

class Stage {
  // Handles the client interpretation of the map, including the hero
  Viewport view; // The main game viewport
  
  Hero hero;
  GameMap map = new GameMap("",[],[[]]); // The map we are currently on
  
  var send; // Send function passed in from the main game object
  
  Stage(this.hero,this.view,this.send) {
    Keyboard.init(); // init inputs
    Mouse.init();
  }
  
  void receive(data) { // receive data from the server, passed from the game
    if (data["cmd"] == "update") { // update from server
      map.unpack(data["map"]);
      hero.unpackRest(data["hero"]);
    }
  }
  void update(num dt) { // update the stage's contents
    // map.update(dt); // try to predict actions on the server
    
    // take user input
    num up=0,down=0,left=0,right=0;
    if (Keyboard.isDown(KeyCode.W)) up = dt;
    if (Keyboard.isDown(KeyCode.S)) down = dt;
    if (Keyboard.isDown(KeyCode.A)) left = dt;
    if (Keyboard.isDown(KeyCode.D)) right = dt;
    send({"cmd": "input",
      "up":up, "down":down,"left":left,"right":right,
      "mousex": Mouse.x + view.x, "mousey" : Mouse.y+view.y,
      "mousedown" : Mouse.down
    });
  }
  
  void draw() { // draw the stage to the screen
    view.clear(); // Clear the screen
    view.drawGameMap(map); // Draw the map
    view.drawInv(hero); // Draw the inventory
    view.drawStats(hero); // Draw the health and mana bars (possibly other stats later)
  }
}