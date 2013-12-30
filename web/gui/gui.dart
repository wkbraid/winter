library gui;
import '../stage/stage.dart';
import '../utils/utils.dart';

class Gui {
  Stage stage;
  Viewport view;

  Gui(this.stage, this.view){ }
  
  void update(){ }
  
  void draw() {
    // get the gui context
    var ctx = view.guicontext; //what class is this thing?
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
    ctx..strokeStyle = "purple"
       ..textAlign = "center";
    int i = 0;
    for (Item key in stage.hero.inv.backpack.keys) {
      int count = stage.hero.inv.backpack[key];
      ctx..fillStyle = key.color
         ..fillRect(610,10+40*i,30,30)
         ..strokeRect(610,10+40*i,30,30)
         ..strokeText(count.toString(), 625, 25+40*i);
      i++;
    }
    //~~~~~~~~~~~spell/hotbar graphics~~~~~~~~~~~~
    
    //draw hotbar/hotcircle
    ctx..strokeStyle = "purple" // red bit
      ..fillStyle = "purple"
      ..lineWidth = 90
      ..beginPath()
        ..arc(30, 400, 30, -3.2, 0, false)
      ..fill()
      ..stroke()
      ..closePath()
      ..fillRect(0, 370, 600, 100);
    
    //draw left click spell icon
    ctx..strokeStyle = "black"
        ..fillStyle = "grey"
        ..lineWidth = 2
        ..beginPath()
        ..ellipse(40, 370, 25, 35, 0, 0, 6.4, false)
        ..fill()
        ..stroke()
        ..closePath()
        ..strokeRect(18, 355, 45, 1)
        ..strokeRect(40, 335, 1, 20)
        //this ought to have an image represeting the spell eventually
        ..lineWidth = 1
        ..strokeText(stage.hero.mousespell, 40, 380, 50)
        ..strokeStyle = "red"
        ..strokeRect(31, 348, 1, 22);
    
    //draw other spell icons
    Map<int,String> spellList = stage.hero.Keybindings;
    drawSpellIcon('Z', 90, 100, spellList);
    drawSpellIcon("X", 88, 170, spellList);
    drawSpellIcon("C", 67, 240, spellList);
    drawSpellIcon("V", 86, 310, spellList);
    drawSpellIcon("T", 84, 380, spellList);
    drawSpellIcon("O", 80, 450, spellList);
    drawSpellIcon("P", 79, 520, spellList);
  }
  void drawSpellIcon(String key, num keyNum, num sideDist, Map<int,String> spellList){
    var ctx = view.guicontext;
    ctx..strokeStyle = "black"
       ..fillStyle = "white"
       ..lineWidth = 1
       ..fillRect(sideDist, 375, 50, 20)
       ..strokeRect(sideDist, 375, 50, 20)
       ..strokeText(key + " : " + spellList[keyNum], sideDist + 25, 390, 50);
  }
}