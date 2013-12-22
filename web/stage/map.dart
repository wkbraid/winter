// file: map.dart
part of stage;

class GameMap {
  // Represents a game map instance
  // Interactions with the map should be abstracted to be independent of
  //  the data representation (later we might want to dynamically load maps)
  
  num ts = 32; // Tile size of tiles in the map
  Viewport view;  // The viewport which the map is drawn to, used to load data only near the current viewport
  
  List<List> data; // Row major representation of the current map data
  List<Actor> actors = []; // All animate objects
  // this distinction is made since later actors will be spawned differently
  
  GameMap(this.data,this.view); // Default map constructor
  
  void checkCollisions(Actor act1) {
    for (Actor act2 in actors) {
      if (act2.x - act2.width/2 < act1.x + act1.width/2
          && act2.x + act2.width/2 > act1.x - act1.width/2
          && act2.y - act2.height/2 < act1.y + act1.height/2
          && act2.y + act2.height/2 > act1.y - act1.height/2) {
          
          act2.collide(act1);
          act1.collide(act2);
        }
    }
  }
  
  void update() { // update the map
    // remove all the dead actors
    actors.removeWhere((act) => act.dead);
    
    // update the other actors
    for (Actor act in actors) {
        act.update();
    }
    
    // actor-actor collision
    for (var i = 0; i < actors.length; i++) {
      Actor act1 = actors[i];
      for (var j = i+1; j < actors.length; j++) {
        Actor act2 = actors[j];
        // check for collision
        if (act1.x - act1.width/2 < act2.x + act2.width/2
          && act1.x + act1.width/2 > act2.x - act2.width/2
          && act1.y - act1.height/2 < act2.y + act2.height/2
          && act1.y + act1.height/2 > act2.y - act2.height/2) {
          act1.collide(act2);
          act2.collide(act1);
        }
      }
    }
  }
  
  void draw() { // draw the map
    var context = view.viewcontext; // get the graphics context from the viewport
    // draw each tile in place
    for (var y = view.y ~/ ts; y <= (view.y + view.height) ~/ ts; y++) {
      for (var x = view.x ~/ ts; x <= (view.x + view.width) ~/ ts; x++) {
        if (x >= 0 && x < data[0].length && y >= 0 && y < data.length) {
          // simple differentiation of colors
          context.fillStyle = (data[y][x] == 0) ? "white" : "black";
          context.fillRect(x*ts,y*ts,ts,ts);
        }
      }
    }
    // draw all other actors
    for (Actor act in actors) {
      act.draw();
    }
  }
  
  // get the tile at position x,y
  num get(x,y) {
    if (x >= 0 && x < data[0].length*ts && y >= 0 && y < data.length*ts)
      return data[y ~/ ts][x ~/ ts];
    else
      return 1; // everything outside the map is unwalkable by default
  }
}