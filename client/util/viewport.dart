// file: viewport.dart
part of util;

class Viewport {
  // Holds information about the current game window
  // Handles scaling and scrolling of the stage
  // Contains all drawing functions for the stage
  CanvasElement canvas; // The game canvas
  CanvasRenderingContext2D get ctx => canvas.context2D; // quick access to canvas context
  
  num get width => canvas.width; // the viewport dimensions
  num get height => canvas.height;
  
  num x = 0,y = 0; // the top left corner of the viewport in map coordinates
  
  Actor following; // The actor the viewport is following
  
  Viewport(this.canvas);
  
  void update() { // update the viewport
    // ctx.translate(x, y); // move back to the origin

    // ctx.translate(-x, -y);
  }
  
  // ==== DRAW FUNCTIONS ====
  void clear() { // Clear the screen
    ctx.clearRect(x, y, width, height);
  }
  void drawGameMap(GameMap m) {
    // Draw the tiles
    var tmp = m.tdata.toList(); // take a copy for concurrency
    for (var j = y ~/ m.ts; j <= (y + height) ~/ m.ts; j++) {
      for (var i = x ~/ m.ts; i <= (x + width) ~/ m.ts; i++) {
        if (i >= 0 && i < m.tdata[0].length && j >= 0 && j < m.tdata.length) {
          // simple differentiation of colors
          switch(m.tdata[j][i]) {
            case Tile.AIR: ctx.fillStyle = "white"; break;
            case Tile.WALL: ctx.fillStyle = "black"; break;
            case Tile.CLOUD: ctx.fillStyle = "gray"; break;
            case Tile.LADDER: ctx.fillStyle = "orange"; break;
            case Tile.ICE: ctx.fillStyle = "lightblue"; break;
          }
          ctx.fillRect(i*m.ts,j*m.ts,m.ts,m.ts);
        }
      }
    }
    
    // Draw the map
    tmp = m.heros.values.toList(); // take a copy for concurrency
    for (Hero hero in tmp) {
      drawActor(hero);
    }
    tmp = m.actors.toList();
    for (Actor act in tmp) {
      drawActor(act);
    }
  }
  void drawActor(Actor act) {
    ctx.fillStyle = act.color;
    ctx.fillRect(act.x-act.width/2, act.y-act.height/2, act.width, act.height);
  }
}
