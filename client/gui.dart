// file: gui.dart
// contains: Gui

library gui;

import 'dart:html';
import '../common.dart';

part 'gui/chathandler.dart';

class Gui {
  
  ChatHandler chat;
  
  var send; // Send function taken from game
  
  Gui(this.send) {
    chat = new ChatHandler("chatInput","chatOutput",send);
  }
  
  //Handles the graphical user interface
  void login(callback) {
    querySelector("#logMeIn").onClick.listen((e) { // login on click of button
      InputElement tf = querySelector("#textfield");
      callback(tf.value);
    });
    querySelector("#textfield").onKeyUp.listen( // login when enter is pressed
        (e) {if (e.keyCode == KeyCode.ENTER){
               InputElement tf = querySelector("#textfield");
               callback(tf.value);}
    });
  }
  
  void listen(){
    querySelector(".nav tr td:nth-child(1)").onClick.listen(
        (e) => toggleVisible(querySelector(".inventory")));
  }
  
  void toggleVisible(DivElement div){
    if (div.style.left == "900px")
      div.style.left = "-5px";
    else div.style.left = "900px";
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
    // draw the hero's stats in the gui
    querySelector(".bar:nth-child(1)").style.width = hero.stats.hpmax.toString() + "px"; // set healthbar border to max hp
    querySelector(".bar:nth-child(2)").style.width = hero.stats.mpmax.toString() + "px"; //set manabar holder to max mp
    querySelector(".health").style.width = hero.hp.toString() + "px"; // set healthbar to hp
    querySelector(".health").text = hero.hp.toString(); // print health
    querySelector(".mana").style.width = hero.mp.toString() + "px"; // set manabar to mp, takes a little to catch up with game logic
    querySelector(".mana").text = hero.mp.toInt().toString(); // print mana
 }
}