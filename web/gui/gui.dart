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
    var ctx = view.guicontext;
    // pretty box
    ctx..fillStyle = "lightgreen"
       ..strokeStyle = "darkgreen"
       ..lineWidth = 2
       ..fillRect(10, 10, 60, 60)
       ..strokeRect(10, 10, 60, 60);
    // health bar
    ctx..fillStyle = "red"
       ..strokeStyle = "darkred"
       ..fillRect(75,13, 160*(stage.hero.hp/stage.hero.hpmax), 15)
       ..strokeRect(75, 13, 160, 15);
    
    // mana bar
    ctx..fillStyle = "blue"
       ..strokeStyle = "darkblue"
       ..fillRect(75, 35, 160*(stage.hero.mp/stage.hero.mpmax), 15)
       ..strokeRect(75, 35, 160, 16);
    
    // buff bar
    ctx.strokeStyle = "black";
    ctx.textAlign = "center";
    for (int i = 0; i < stage.hero.buffs.length; i++) {
      ctx.fillStyle = stage.hero.buffs[i].color;
      ctx.fillRect(575 - i*25, 5, 20, 20);
      ctx.strokeText(stage.hero.buffs[i].duration.toString(), 587 - i*25, 17);
    }
           
    // the right side of the screen belongs to the gui
    ctx..fillStyle = "thistle"
       ..strokeStyle = "violet"
       ..fillRect(600,0,50,400)
       ..strokeRect(600,0,50,400);
    
    // draw the hero's items in the gui
    ctx..fillStyle = "violet"
        ..strokeStyle = "purple";
    for (int i = 0; i < stage.hero.inv.length; i++) {
      ctx..fillRect(610,10+40*i,30,30)
         ..strokeRect(610,10+40*i,30,30);
    }
  }
}