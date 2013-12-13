import 'dart:html';
import 'keyboard.dart';

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
  
  Viewport(this.canvas, {this.width, this.height}) {
    // if no dimensions are provided, take the entire canvas by default
    if (width == null) width = canvas.width;
    if (height == null) height = canvas.height;
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

class Actor {
  // Base class for all map dwellers
  
  // The map the actor is on
  Map map;
  
  // Actor dimensions
  num x,y,width,height;
  
  Actor(this.map,this.x,this.y);
  
  void update() {
    
  }
  
  void draw() {
    
  }
  
}

class Hero extends Actor {
  // Our very own hero!
  
  // Call the default actor constructor
  Hero(map,x,y) : super(map,x,y) {
    // set the hero's height
    height = 28;
    width = 20;
  }
  
  void update() {
    if (Keyboard.isDown(KeyCode.LEFT)) x -= 2;
    if (Keyboard.isDown(KeyCode.RIGHT)) x += 2;
    if (Keyboard.isDown(KeyCode.UP)) y -= 2;
    if (Keyboard.isDown(KeyCode.DOWN)) y += 2;
  }
  
  void draw() {
    // get the viewcontext from the map we are on
    var context = map.view.viewcontext;
    context.fillStyle = "red";
    context.lineWidth = 2;
    context.strokeStyle = "darkred";
    context.fillRect(x-width/2, y-width/2, width, height);
    context.strokeRect(x-width/2, y-width/2, width, height);
  }
}

// Game variables
Viewport view;
Actor hero;
Map map;


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
  
  // set up our basic world
  view = new Viewport(canvas);
  map = new Map(mdata,view);
  hero = new Hero(map,50,50);
  view.follow(hero);
  
  // Initialize keyboard interaction
  Keyboard.init();
  
  // start the main game loop
  window.requestAnimationFrame(loop);
}

void loop(num time) {
  // update the hero
  hero.update();
  
  // update the viewport
  view.update();
  // note currently does not clear the screen
  // draw the map
  map.draw();
  hero.draw();
  
  // ask for the next cycle
  window.requestAnimationFrame(loop);
}