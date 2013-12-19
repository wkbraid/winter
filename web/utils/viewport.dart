// file: viewport.dart
part of utils;

class Viewport {
  // Holds information about the current game viewpoint
  // Handles scale and scrolling
  
  // The canvas which the viewport is linked to
  CanvasElement canvas;
  
  // The actor we are currently following
  Actor following;
  
  // The current visible rectangle
  num x,y,width,height;
  
  // the hole screen size
  num fullwidth, fullheight;
  
  // Is the context currently located at the origin (ie where the gui will be drawn)
  bool origin = true;
  
  Viewport(this.canvas, {this.width, this.height}) {
    // if no dimensions are provided, take the entire canvas by default
    if (width == null) width = canvas.width;
    if (height == null) height = canvas.height;
    fullwidth = canvas.width;
    fullheight = canvas.height;
  }
  
  // follow an actor
  void follow(tofollow) {
    following = tofollow;
  }
  
  // get the context for drawing the game map
  CanvasRenderingContext2D get viewcontext {
     if (origin) {
       // move the canvas to the view position
       canvas.context2D.translate(-x, -y);
     }
     origin = false;
     return canvas.context2D;
  }
  
  // get the context for drawing the game gui
  CanvasRenderingContext2D get guicontext {
    if (!origin) {
      // move the canvas back to its original position
      canvas.context2D.translate(x, y);
    }
    origin = true;
    return canvas.context2D;
  }
  
  // return the current viewable rectangle
  Rectangle get rect {
    new Rectangle(x,y,width,height);
  }
  
  void update() {
    // move the canvas context back to the origin
    if (!origin) {
      canvas.context2D.translate(x, y);
    }
    origin = true;
    // center the viewport on following
    // could add smooth movement towards following probably
    x = following.x - width/2;
    y = following.y - height/2;
  }
}
