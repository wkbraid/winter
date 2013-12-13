// file: map.dart
part of stage;

class Tile {
  //Represents a piece of the map 
  //The size of the tile
  num ts;
  //Location of the center of the tile
  num x, y;
  //Tile "type"
  num type;
  
  Tile(this.x, this.y, this.ts, this.type);  
}

class GameMap {
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
  GameMap(this.data,this.view);
  
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
  
  //finds the tile that the Actor will be moving to
  List<Tile> collisions(List<Point> points) {
    return points.map((p) {
      // cheating
      num ty = (p.y- 0.001) ~/ ts;
      num tx = p.x ~/ ts;
      num ttype;
      if ((tx > 0 && tx < data[0].length) && (ty > 0 && ty < data.length))
        ttype = data[ty][tx];
      else
        ttype = 1;
      return new Tile(tx * ts, ty * ts, ts, ttype);
    }).toList();
  }
  
  List<Tile> collisionsLeft(x,y,width,height) {
    return collisions([new Point(x-width/2, y-height/2 + 0.001), 
                       new Point(x-width/2, y+height/2 - 0.001)]);
  }
  List<Tile> collisionsRight(x,y,width,height) {
    return collisions([new Point(x+width/2, y-height/2 + 0.001), 
                       new Point(x+width/2, y+height/2 - 0.001)]);
  }
  List<Tile> collisionsUp(x,y,width,height) {
    return collisions([new Point(x-width/2 + 0.001, y-height/2), 
                       new Point(x+width/2 - 0.001, y-height/2)]);
  }
  List<Tile> collisionsDown(x,y,width,height) {
    return collisions([new Point(x-width/2 + 0.001, y+height/2),
                       new Point(x+width/2 - 0.001, y+height/2)]);
  }
}