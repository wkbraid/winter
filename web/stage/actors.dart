// file: actors.dart
part of stage;


class Actor {
  // Base class for all map dwellers
  
  // The map the actor is on
  GameMap map;
  
  // Actor dimensions: x,y are the current coordinates of the actor,
  //width and height are the size of the actor
  //vx and vy and are the x and y velocities of the actor
  num x,y,width,height,vx,vy;
  bool down = false;
  
  Actor(this.map,this.x,this.y,this.vx,this.vy);
  
  void update() {
    
  }
  
  void draw() {
    
  }
  
  // Can the actor walk through this list of tiles
  Tile walkable(Iterable tiles) {
    
  }
  
  // handles movement of the actor
  void move(num movex, num movey) {
    // break movement into steps
    // collision error on corners will be precise to this magnitude
    num stepx = width;
    num stepy = height;
    
    num dx, dy;
    // take either a full step or as much movement as is left
    if (movex.abs() > stepx) dx = stepx * (movex / movex.abs());
    else dx = movex;
    if (movey.abs() > stepy) dy = stepy * (movey / movey.abs());
    else dy = movey;
    // calculate how much more we have to move
    movex -= dx;
    movey -= dy;
    
    this.down = false;
    
    // VERTICAL MOVEMENT
    if (dy > 0) {
      // look down
      var down = walkable(map.collisionsDown(x, y + dy, width, height));
      if (down != null) { // we have a collision!
        y = down.y - height/2;
        dy = 0;
        vy = 0;
        movey = 0;
        this.down = true;
      }
    } else if (dy < 0) {
      // look right
      var up = walkable(map.collisionsLeft(x, y + dy, width, height));
      if (up != null) {
        y = up.y + up.ts + height/2;
        dy = 0;
        vy = 0;
        movey = 0;
      }
    }
    

    y += dy;
    
    // HORIZONTAL MOVEMENT 
    if (dx > 0) {
      // look right
      var right = walkable(map.collisionsRight(x + dx, y, width, height));
      if (right != null) { // we have a collision!
        x = right.x - width/2;
        dx = 0;
        vx = 0;
        movex = 0;
      }
    } else if (dx < 0) {
      // look left
      var left = walkable(map.collisionsLeft(x + dx, y, width, height));
      if (left != null) {
        x = left.x + left.ts + width/2;
        dx = 0;
        vx = 0;
        movex = 0;
      }
    }

    
    x += dx;
    if (movex.truncate() != 0 || movey.truncate() != 0) {
      //move(movex, movey);
    }
  }
}