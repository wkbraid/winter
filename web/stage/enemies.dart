// file: enemies.dart
part of stage;

class Enemy extends Being {
  // Basic enemy class, abstracts most functionality other than AI decisions
  
  Enemy(x,y,stage) : super(x,y,stage) {
    type = "enemy"; // set the type
    color = "lightgreen"; // drawing colors
    bordercolor = "green";
  }
  
  // placeholder functions
  void decide() { } // Implement decision making for the enemy
  
  void update() {
    decide(); // implements the decision making step
    vy += g; // gravity
    vx *= mu; // friction
    vy *= mu;
    move(vx,vy); // move the enemy
    
    dead = hp <= 0; // check if the enemy is dead
  }
  
  void collide(Actor other) {
    if (other.type == "projectile")
      hp -= 1;
  }
}

//=============================================
// Game Enemies
//=============================================

class RandEnemy extends Enemy {
  // Basic enemy with randomized movement
  RandEnemy(x,y,stage) : super(x,y,stage) {
    width = 20;
    height = 20;
  }
  void decide() {
    // decide whether we should randomly jump
    var rand = new Random();
    if (rand.nextDouble() < 0.01 && down)
      vy -= 18;
    // now decide which way we should push
    if (vx.abs() < 1)
      vx += (rand.nextDouble() - 0.5);
    else
      vx += vx/14;
  }
}

class FlyingEnemy extends Enemy {
  // Basic flying enemy
  FlyingEnemy(x,y,stage) : super(x,y,stage) {
    width = 40;
    height = 15;
  }
  void decide() {
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
  }
}