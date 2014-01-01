// file: stage.dart
// contains: Stage

library stage;

import 'dart:html';

import '../common.dart';
import 'util/utils.dart';

class Stage {
  // Handles the client interpretation of the map, including the hero
  Viewport view; // The main game viewport
  
  Hero hero;
  Instance instance; // The map we are currently on
  
  var send; // Send function passed in from the main game object
  
  Stage(this.hero,this.view,this.send) {
    Keyboard.init(); // init inputs
    Mouse.init();
  }
  
  void receive(data) { // receive data from the server, passed from the game
    if (instance == null) instance = new Instance.fromPack(data["instance"]); // TODO: move this
    if (data["cmd"] == "update") { // update from server
      instance.unpack(data["instance"]);
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
      "mousex": Mouse.x, "mousey" : Mouse.y,
      "mousedown" : Mouse.down
    });
  }
    
  void draw() { // draw the stage to the screen
    if (instance != null) { // ie only if we have recieved an update already
      view.clear(); // Clear the screen
      view.drawInstance(instance); // Draw the map
      view.drawOverlay(hero);
    }
  }
}