// file: enemies.dart
part of stage;

class RandEnemy extends Being {
  // Basic enemy with randomized movement,
  // if moving left, more likely to accel in that direction
  
  RandEnemy(x,y,stage) : super(x,y,stage) {
    type = "enemy";
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
  
  void collide(Actor other) {
    if (other.type == "projectile")
      dead = true;
  }
  void draw() {
    // get the viewcontext from the map we are on
    var context = stage.view.viewcontext;
    context.fillStyle = "lightgreen";
    context.lineWidth = 1;
    context.strokeStyle = "green";
    context.fillRect(x-width/2, y-height/2, width, height);
    context.strokeRect(x-width/2, y-height/2, width, height);
  }
}

class FlyingEnemy extends Actor {
// Basic enemy with randomized movement,
  // if moving left, more likely to accel in that direction
  FlyingEnemy(x,y,stage) : super(x,y,stage) {
    width = 40;
    height = 15;
  }
  
  void update() {
    // decide whether we should randomly jump
    var dir = vy.toDouble();
    var rand = new Random();
    if (rand.nextDouble() < 0.1)

      vy -= 1.7;
    else if (rand.nextDouble() > 0.9)
      vy +=0.3;
    else
      vy-= 0.7;

    // now decide which way we should push
    if (vx.abs() < 1)
      vx += (rand.nextDouble() - 0.7);
    else
      vx += vx/14;
    
    // physics
    vx *= 0.95; //horizontal fricton
    vy += 0.7; // gravity
  
    if (dir > vy)
      vy *= 1.05;
    else if (dir == vy)
      vy *= 1;
    else
      vy *= 0.95; //vertical friction
    move(vx,vy);
  }
  void draw() {
    // get the viewcontext from the map we are on
    var context = stage.view.viewcontext;
    context.fillStyle = "lightgreen";
    context.lineWidth = 1;
    context.strokeStyle = "blue";
    context.fillRect(x-width/2, y-height/2, width, height);
    context.strokeRect(x-width/2, y-height/2, width, height);
  }
}