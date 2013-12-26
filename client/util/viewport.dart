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
  
  Viewport(this.canvas);
  
  void update() { // update the viewport
    //ctx.translate(x, y); // move back to the origin

    //ctx.translate(-x, -y);
  }
  
  // ==== DRAW FUNCTIONS ====
  void clear() { // Clear the screen
    ctx.clearRect(x, y, width, height);
  }
  void drawGameMap(GameMap m) {
    var tmp = m.players.values.toList(); // take a copy for concurrency
    for (Player p in tmp) {
      drawPlayer(p);
    }
  }
  void drawPlayer(Player p) {
    ctx.fillStyle = p.color;
    ctx.fillRect(p.x-p.width/2, p.y-p.height/2, p.width, p.height);
  }
}
