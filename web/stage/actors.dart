// file: actors.dart
part of stage;


class Actor {
  // Base class for all map dwellers
  
  // The map the actor is on
  GameMap map;
  
  // Actor dimensions
  num x,y,width,height;
  
  Actor(this.map,this.x,this.y);
  
  void update() {
    
  }
  
  void draw() {
    
  }
  
}