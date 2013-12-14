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
  
  Actor(this.map,this.x,this.y,this.vx,this.vy);
  
  void update() {
    
  }
  
  void move(dx,dy) {
    num ts = 32; // should probably come from constants somewhere
    
    // split the movement into tile size steps, using projective collision avoidance at each step
    num restx, resty;
    if (dx > ts) {
      restx = dx - ts;
      dx = ts;
    } else restx = 0;
    if (dy > ts) {
      resty = dy - ts;
      dy = ts;
    } else resty = 0;
    
    x += dx;
    y += dy;
    
    map.collide(this);
    
    // if there is more movement to do, recur
    if (restx != 0 || resty != 0)
      move(restx, resty);
  }
  
  void draw() {
    
  }
}