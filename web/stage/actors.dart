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
  
  void draw() {
    
  }
}