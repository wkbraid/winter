// file: gui.dart
// contains: Gui

library gui;

import 'dart:html';
import '../common.dart';

part 'gui/chathandler.dart';

class Gui {
  
  ChatHandler chat;
  
  //Overlay types
  static const NO_OVERLAY = 0;
  static const INVENTORY_OVERLAY = 1;
  static const STATS_OVERLAY = 2;
  static const BANK_OVERLAY = 3;
  static const NPC_CHAT_OVERLAY = 4;
  static const MAP_OVERLAY = 5;
  // Number that determines what overlay is covering the main game screen (if any).
  int overlayStatus;
  
  var send; // Send function taken from game
  
  Gui(this.send) {
    chat = new ChatHandler("chatInput","chatOutput",send);
    overlayStatus = 0;
  }
  
  //Handles the graphical user interface
  void login(callback) {
    querySelector("#logMeIn").onClick.listen((e) {
      InputElement tf = querySelector("#textfield");
      callback(tf.value);
    });
  }
  
  void listen(){
    querySelector(".nav tr td:nth-child(1)").onClick.listen(
        (e) { emptyWindow([querySelector(".stats")]);
              querySelector(".equipment").classes.remove("hide");
              querySelector(".backpack").classes.remove("hide");
              toggleVisible(querySelector(".window")); // creates some problems when switching between pages, should be fixed with enum
         });
    querySelector(".nav tr td:nth-child(2)").onClick.listen(
        (e) { emptyWindow([querySelector(".equipment"), querySelector(".backpack")]);
              querySelector(".stats").classes.remove("hide");
              toggleVisible(querySelector(".window"));
         });
  }
  
  void drawOverlay(Hero hero){
    DivElement window = querySelector(".window");
    DivElement equipment = querySelector(".equipment");
    DivElement backpack = querySelector(".backpack");
    DivElement stats = querySelector(".stats");
    switch(hero.overlay){
      case NO_OVERLAY: 
        hide(window);
        emptyWindow([equipment, backpack, stats]);
        return;
      case INVENTORY_OVERLAY: 
        hide(window);
        emptyWindow([stats]);
        fillWindow([equipment, backpack]);
        drawInv(hero);
        show(window);
        return;
      case STATS_OVERLAY: 
        hide(window);
        emptyWindow([equipment, backpack]);
        fillWindow([stats]);
        show(window);
        return;
      case BANK_OVERLAY: 
        hide(window);
        emptyWindow([equipment, backpack, stats]);
        show(window);
        return;
      case NPC_CHAT_OVERLAY: // may not use window
        hide(window);
        emptyWindow([equipment, backpack, stats]);
        show(window);
        return;
      case MAP_OVERLAY: 
        hide(window);
        emptyWindow([equipment, backpack, stats]);
        show(window);
        return;
      default: break;
    }
  }
  
  void emptyWindow(List<DivElement> divs){
    for(DivElement div in divs)
      div.classes.add("hide");
  }
  
  void fillWindow(List<DivElement> divs){
    for(DivElement div in divs)
      div.classes.remove("hide");
  }
  
  void toggleVisible(DivElement div){
    if (div.style.left == "900px")
      div.style.left = "-5px";
    else div.style.left = "900px";
  }
  
  void show(DivElement div){ 
    div.style.left = "-5px";
  }
  
  void hide(DivElement div){
    div.style.left == "900px";
  }
  
  void drawInv(Hero hero){
    // draw the hero's items in the gui
    int i = 1;
    querySelector(".backpack").children=[];
    querySelector(".equipment").children=[];
    for (Item key in hero.inv.backpack.keys) {
      int count = hero.inv.backpack[key];
      if(i <= 7){
      TableCellElement obj = querySelector(".items td:nth-child("+i.toString()+")");
      obj.classes.remove("empty");
      obj.style.background = key.color;
      obj.style.border = "1px solid black";
      obj.text = count.toString();
      }
      if (i > 7){
        DivElement obj = new DivElement();
        obj.classes.add("bp_obj");
        obj.style.background = key.color;
        obj.text = count.toString();
        querySelector(".backpack").children.add(obj);
      }
      i++;
    }
    for(Equipable eq in hero.inv.equipment){
      if(eq != null){
        DivElement obj = new DivElement();
        obj.classes.add("bp_obj");
        obj.style.background = eq.color;
        querySelector(".equipment").children.add(obj);
      }
    }
  }
  
  void drawStats(Hero hero){
    querySelector(".stats").text = hero.name + " Speed: " + hero.stats.speed.toString()
                                   + " Jump: " + hero.stats.jump.toString();
 }

  
  void drawBars(Hero hero){
    // draw the hero's stats in the gui
    querySelector(".bar:nth-child(1)").style.width = hero.stats.hpmax.toString() + "px"; // set healthbar border to max hp
    querySelector(".bar:nth-child(2)").style.width = hero.stats.mpmax.toString() + "px"; //set manabar holder to max mp
    querySelector(".health").style.width = hero.hp.toString() + "px"; // set healthbar to hp
    querySelector(".health").text = hero.hp.toString(); // print health
    querySelector(".mana").style.width = hero.mp.toString() + "px"; // set manabar to mp, takes a little to catch up with game logic
    querySelector(".mana").text = hero.mp.toInt().toString(); // print mana
 }
}