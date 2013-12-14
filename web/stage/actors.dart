// file: actors.dart
part of stage;


class Actor {
  // Base class for all map dwellers
  
  // this really shouldn't be here
  num ts = 32;
  
  // The map the actor is on
  GameMap map;
  
  // is the actor touching anything in the downwards direction
  bool down = false;
  
  // Actor dimensions: x,y are the current coordinates of the actor,
  //width and height are the size of the actor
  //vx and vy and are the x and y velocities of the actor
  num x,y,width,height,vx,vy;
  
  Actor(this.map,this.x,this.y,this.vx,this.vy);
  
  void update() {
    
  }
  
  void move(num dx, num dy) {
    // reset ground status
    down = false;
    
    // HORIZONTAL MOVEMENT
    if (dx > 0) {
      // check right
      var right = sumHorz(x+dx+width/2);
      if (right != 0) {
        vx = 0; // stop the horizontal speed
        dx = 0; // don't move any farther
      }
    }else if (dx < 0) {
      // check left
      var left = sumHorz(x+dx-width/2);
      if (left != 0) {
        vx = 0; // stop the horizontal speed
        dx = 0; // don't move any farther
      }
    }
    
    // VERTICAL MOVEMENT
    if (dy > 0) {
      // check downwards
      var downwards = sumVert(y+dy+height/2);
      if (downwards != 0) {
        vy = 0; // stop the vertical speed
        dy = 0; // don't move any farther
        down = true;
      }
    }else if (dy < 0) {
      // check upwards
      var upwards = sumVert(y+dy-height/2);
      if (upwards != 0) {
        vy = 0; // stop the vertical speed
        dy = 0; // don't move any farther
      }
    }
    
    y += dy;
    x += dx;
  }
  
  // sum over the map coordinates along the ypos along the edge along the width of the actor
  num sumVert(ypos) {
    num sum = 0;
    for (num xpos = x - width/2; xpos < x + width/2; xpos += ts/2) {
      sum += map.get(xpos, ypos);
    }
    return sum + map.get(x + width/2, ypos);
  }
  
  // sum over the map coordinates along the xpos along the edge along the height of the actor
  num sumHorz(xpos) {
    num sum = 0;
    for (num ypos = y - height/2; ypos < y + height/2; ypos += ts/2) {
      sum += map.get(xpos, ypos);
    }
    return sum + map.get(xpos,y+height/2);
  }
  
  void draw() {
    
  }
}