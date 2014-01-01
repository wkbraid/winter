// file: viewport.dart
part of util;

class Viewport {
  // Holds information about the current game window
  // Handles scaling and scrolling of the stage
  // Contains all drawing functions for the stage
  CanvasElement canvas; // The game canvas
  CanvasRenderingContext2D get ctx => canvas.context2D; // quick access to canvas context
  
  num get width => canvas.width; // the size of the screen available to the stage
  num get height => canvas.height;
  
  Viewport(this.canvas);
  
  // ==== DRAW FUNCTIONS ====
  void clear() { // Clear the screen
    ctx.clearRect(0, 0, width, height);
  }
  void drawInstance(Instance inst) {
    // Draw the tiles
    var tmp = inst.map.tdata.toList(); // take a copy for concurrency
    for (int j = 0; j < tmp.length; j++) {
      for (int i = 0; i < tmp[j].length; i++) {
        switch(inst.map.tdata[j][i]) {
          case Tile.AIR: ctx.fillStyle = "white"; break;
          case Tile.WALL: ctx.fillStyle = "black"; break;
          case Tile.CLOUD: ctx.fillStyle = "gray"; break;
          case Tile.LADDER: ctx.fillStyle = "orange"; break;
          case Tile.ICE: ctx.fillStyle = "lightblue"; break;
        }
        ctx.fillRect(i*ts,j*ts,ts,ts);
      }
    }
    
    // Draw the Actor
    tmp = inst.heros.values.toList(); // take a copy for concurrency
    for (Hero hero in tmp) {
      drawActor(hero);
    }
    tmp = inst.actors.toList();
    for (Actor act in tmp) {
      drawActor(act);
    }
  }
  void drawActor(Actor act) {
    ctx.fillStyle = act.color;
    ctx.fillRect(act.x-act.width/2, act.y-act.height/2, act.width, act.height);
    
  }
  
  void drawInv(Hero hero){
    // draw the hero's items in the gui
    int i = 1;
    querySelector("#backpack").children=[];
    querySelector("#equipment").children=[];
    for (Item key in hero.inv.backpack.keys) {
      int count = hero.inv.backpack[key];
      if(i <= 7){
      TableCellElement obj = querySelector(".items td:nth-child("+i.toString()+")");
      obj.id = key.id;
      obj.classes.remove("empty");
      obj.style.background = key.color;
      obj.style.border = "1px solid black";
      obj.text = count.toString();
      }
      if (i > 7){
        DivElement obj = new DivElement();
        obj.id = key.id;
        obj.classes.add("bp_obj");
        obj.style.background = key.color;
        obj.text = count.toString();
        querySelector("#backpack").children.add(obj);
      }
      i++;
    }
    for(Equipable eq in hero.inv.equipment){
      if(eq != null){
        DivElement obj = new DivElement();
        obj.id = eq.id;
        obj.classes.add("bp_obj");
        obj.style.background = eq.color;
        querySelector("#equipment").children.add(obj);
      }
    }
  }

  
  void drawStats(Hero hero){
    // draw the hero's stats in the gui
    querySelector("#bar:nth-child(1)").style.width = hero.stats.hpmax.toString() + "px"; // set healthbar border to max hp
    querySelector("#bar:nth-child(2)").style.width = hero.stats.mpmax.toString() + "px"; //set manabar holder to max mp
    querySelector(".health").style.width = hero.hp.toString() + "px"; // set healthbar to hp
    querySelector(".health").text = hero.hp.toString(); // print health
    querySelector(".mana").style.width = hero.mp.toString() + "px"; // set manabar to mp, takes a little to catch up with game logic
    querySelector(".mana").text = hero.mp.toInt().toString(); // print mana
 }
  
}
