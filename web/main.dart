import 'dart:html';
import 'utils/utils.dart';
import 'stage/stage.dart';
import 'gui/gui.dart';
import 'user/account.dart';

class Game {
  // The main game object, keeps track of global variables
  // The main viewport everything should draw to
  Viewport view;
  Stage stage;
  Gui gui;
  
  Game(account,canvas) {
    view = new Viewport(canvas, width: 900);
    stage = new Stage(account, view);
    gui = new Gui(stage,view);
    
    // Initialize mouse and keyboard interaction
    Keyboard.init();
    Mouse.init();
    
    // start the main game loop
    window.requestAnimationFrame(loop);
  }
  
  // The main game loop
  void loop(num time) {
    // update the stage
    stage.update();
    
    view.update(); // update the viewport
    gui.update(); // update the gui
    // clear the viewport
    view.guicontext.clearRect(0, 0, view.fullwidth, view.fullheight);
    // draw the stage
    stage.draw();
    gui.draw();
    
    // ask for the next cycle
    window.requestAnimationFrame(loop);
  }
}

void main() {
  // get the main canvas from the page
  var canvas = querySelector("#area");
  
  var game = new Game(new Account("knarr"), canvas);
}