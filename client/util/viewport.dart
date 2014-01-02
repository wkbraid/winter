// file: viewport.dart
// contains: Viewport

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
  void drawTiles(List<List<int>> tdata) {
    // Draw the tiles
    var tmp = tdata.toList(); // take a copy for concurrency
    for (int j = 0; j < tmp.length; j++) {
      for (int i = 0; i < tmp[j].length; i++) {
        switch(tdata[j][i]) {
          case Tile.AIR: ctx.fillStyle = "white"; break;
          case Tile.WALL: ctx.fillStyle = "black"; break;
          case Tile.CLOUD: ctx.fillStyle = "gray"; break;
          case Tile.LADDER: ctx.fillStyle = "orange"; break;
          case Tile.ICE: ctx.fillStyle = "lightblue"; break;
          case Tile.BANK: ctx.fillStyle = "Gold"; break;
        }
        ctx.fillRect(i*ts,j*ts,ts,ts);
      }
    }
  }
  void drawInstance(Instance inst) {
    // Draw the tiles
    drawTiles(inst.map.tdata);
    
    // Draw the Actor
    var tmp = inst.heros.values.toList(); // take a copy for concurrency
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
    if(act is Being){
      ctx.fillStyle = "red";
      print("hpmax:" + act.stats.hpmax.toString());
      ctx.fillRect(act.x-act.width/2, act.y-act.height, act.hp, 5);
    }
    
  }
  
 
  
  
  //OverLay Constants
  static const NOVERLAY = 0;
  static const BANKOVERLAY = 1;
  
  void drawOverlay(Hero hero){
    print(hero.overlay);
    ctx.fillStyle = "grey";
    switch(hero.overlay){
      case 0: break;
      case 1:
        print("and got here");
        ctx.fillRect(100, 100, 400, 300);
        break;
      default: break;
    }
  }
  
}
