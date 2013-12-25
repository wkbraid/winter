// file: viewport.dart
part of util;

class Viewport {
  // Holds information about the current game window
  // Handles scaling and scrolling of the stage
  CanvasElement canvas; // The game canvas
  
  num get width => canvas.width; // the viewport dimensions
  num get height => canvas.height;
  
  num x,y; // the top left corner of the viewport in map coordinates
  
  Viewport(this.canvas);
  
  void update() { // update the viewport
    //canvas.context2D.translate(x, y); // move back to the origin

    //canvas.context2D.translate(-x, -y);
  }
}
