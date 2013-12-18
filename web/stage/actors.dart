// file: actors.dart
part of stage;

class RandEnemy extends Actor {
  // Basic enemy with randomized movement,
  // if moving left, more likely to accel in that direction
  RandEnemy(x,y,map,actors) : super(x,y,map,actors) {
    width = 20;
    height = 20;
  }
  
  void update() {
    // decide whether we should randomly jump
    var rand = new Random();
    if (rand.nextDouble() < 0.01 && down)
      vy -= 18;
    // now decide which way we should push
    if (vx.abs() < 1)
      vx += (rand.nextDouble() - 0.5);
    else
      vx += vx/14;
    
    // physics
    vx *= 0.95; //horizontal fricton
    vy += 0.7; // gravity
    vy *= 0.95; //vertical friction
    move(vx,vy);
  }
  void draw() {
    // get the viewcontext from the map we are on
    var context = map.view.viewcontext;
    context.fillStyle = "lightgreen";
    context.lineWidth = 1;
    context.strokeStyle = "green";
    context.fillRect(x-width/2, y-height/2, width, height);
    context.strokeRect(x-width/2, y-height/2, width, height);
  }
}

class Actor {
  // Base class for all map dwellers
  
  // this really shouldn't be here
  num ts = 32;
  
  // The map the actor is on
  GameMap map;
  
  // the actors currently on the stage
  List<Actor> actors;
  
  // is the actor touching anything in the downwards direction
  bool down = false;
  
  // Actor dimensions: x,y are the current coordinates of the actor,
  //width and height are the size of the actor
  //vx and vy and are the x and y velocities of the actor
  num x,y,width,height;
  num vx = 0;
  num vy = 0;
  
  Actor(this.x,this.y, this.map, this.actors);
  
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
        dx = collideX(dx);
      }
    }else if (dx < 0) {
      // check left
      var left = sumHorz(x+dx-width/2);
      if (left != 0) {
        dx = collideX(dx);
      }
    }
    
    // VERTICAL MOVEMENT
    if (dy > 0) {
      // check downwards
      var downwards = sumVert(y+dy+height/2);
      if (downwards != 0) {
        dy = collideY(dy);
      }
    }else if (dy < 0) {
      // check upwards
      var upwards = sumVert(y+dy-height/2);
      if (upwards != 0) {
        dy = collideY(dy);
      }
    }
    
    y += dy;
    x += dx;
  }
  
  num collideX(num dx) {
    vx = 0;
    return 0;
  }
  
  num collideY(num dy) {
    if (dy > 0) down = true;
    vy = 0;
    return 0;
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
  
  bool dead() {
    return false;
  }
  
  void draw() {
    
  }
}