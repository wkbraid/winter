library gui;
import 'dart:html';
import '../stage/stage.dart';
import '../utils/utils.dart';

class Gui {
  Stage stage;
  Viewport view;
  
  Gui(this.stage, this.view);
  
  update() {
    if (Keyboard.isDown(KeyCode.E))
      print(stage.hero.inv);
  }
  
  draw() {
    // get the gui context
    var context = view.guicontext;
    // pretty box
    context..fillStyle = "lightgreen"
           ..strokeStyle = "darkgreen"
           ..lineWidth = 2
           ..fillRect(10, 10, 60, 60)
           ..strokeRect(10, 10, 60, 60);
    // health bar
    context..fillStyle = "red"
           ..strokeStyle = "darkred"
           ..fillRect(75,13, 160*(stage.hero.hp/stage.hero.hpmax), 15)
           ..strokeRect(75, 13, 160, 15);
    
    // mana bar
    context..fillStyle = "blue"
           ..strokeStyle = "darkblue"
           ..fillRect(75, 35, 160*(stage.hero.mp/stage.hero.mpmax), 15)
           ..strokeRect(75, 35, 160, 16);
           
    
           
  }
}