import 'dart:html';

class Map {
  // Represents a game map instance
  // Interactions with the map should be abstracted to be independent of
  //  the data representation (later we might want to dynamically load maps)
  
  // Row major representation of the current map data
  List<List> data;
  // Tile size of tiles in the map
  num ts = 32;
  
  // The viewport which the map is drawn to, used to load data only near the current viewport
  Viewport view;
  
  // Default map constructor
  Map(this.data,this.view);
  
  // draw the map to the given canvas
  void draw() {
    // get the graphics context from the viewport
    // TODO: only draw tiles in the viewport rectangle
    var context = view.viewcontext;
    // draw each tile in place
    for (var y = 0; y < data.length; y++) {
      for (var x = 0; x < data[0].length; x++) {
        // simple differentiation of colors
        context.fillStyle = (data[y][x] == 0) ? "white" : "black";
        context.fillRect(x*ts,y*ts,ts,ts);
      }
    }
  }
}

class Viewport {
  // Holds information about the current game viewpoint
  // Handles scale and scrolling
  
  // The canvas which the viewport is linked to
  CanvasElement canvas;
  
  // The actor we are currently following
  Actor following;
  
  // The current visible rectangle
  num x,y,width,height;
  
  // Is the context currently located at the origin (ie where the gui will be drawn)
  bool origin = true;
  
  Viewport(this.following, this.canvas);
  
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
    Rectangle(x,y,width,height);
  }
  
  void update() {
    // move the canvas context back to the origin
    if (!origin) {
      canvas.context2D.translate(x, y);
    }
    origin = true;
    x = following.x;
    y = following.y;
  }
}

class Actor {
  // Base class for all map dwellers
  
  // Current x and y coordinates of the actor
  num x,y;
  
  Actor(this.x,this.y);
}

void main() {
  List<List> mdata = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,1],
                      [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
  
  // get the main canvas from the page
  var canvas = querySelector("#area");
  
  var hero = new Actor(50,50);
  var view = new Viewport(hero,canvas);
  view.update();
  var map = new Map(mdata,view);
  map.draw();
  hero.x = 200;
  view.update();
  map.draw();
}