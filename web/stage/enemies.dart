// file: enemies.dart
part of stage;

class Enemy extends Being {
  // Basic enemy class, abstracts most functionality other than AI decisions
  
  Enemy(x,y,stage) : super(x,y,stage) {
    color = "lightgreen"; // drawing colors
    bordercolor = "green";
  }
  
  void update() {
    if (hp <= 0) dead = true; // check if the enemy is dead
    super.update();
  }
  
  void collide(Actor other) {
    if (other is Projectile)
      hp -= other.damage;
  }
  void draw() {
    var ctx = stage.view.viewcontext;
    ctx.fillStyle = "red";
    ctx.strokeStyle = "darkred";
    ctx.fillRect(x-hp/10, y-8-height/2, hp/5, 5);
    ctx.lineWidth = 1;
    ctx.strokeRect(x-hp/10,y-8-height/2,hp/5,5);
    
    super.draw(); // draw the enemy body
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
    
    super.update(); // physics and move the enemy
  }
}

class FlyingEnemy extends Enemy {
  // Basic flying enemy
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
    
    super.update(); // physics and move
  }
}

class FollowerEnemy1 extends Enemy {
  // This is a following testing AI creature
  // The actor the enemy is trying to follow
  Actor target;
  //default constructor
  FollowerEnemy1(x,y,stage,Actor) : super(x,y,stage) {
    super.color = "blue";
    super.bordercolor = 'blue';
    width = 30;
    height = 30;
    target = Actor; // sets inputted actor as target
  } 
  void update() {
    var rand = new Random();
    // if target's alive, follow it, otherwise die.
    if(target.dead)
      dead = true;
    
    if (target.x > this.x)
      vx += 0.1;
    else
      vx -= 0.1;
    if (vx.abs() < 0.5 && down) // jump if moving slowly (bad collision detection)
      vy -= 18;
    
    super.update();
  }
}

class FollowerEnemy2 extends Enemy{
  Actor target;
  num patience;
  //default constructor
  FollowerEnemy2(x,y,stage,Actor) : super(x,y,stage) {
    width = 25;
    height = 30;
    super.color = 'orange';
    super.bordercolor = 'blue';
    patience = 1;
  }
  
  void update(){
    switch(patience){
      case 1: 
        x += 10;
        break;
      case 2:
        y += 18;
        break;
      default:
        break;
      }
    super.update();
  }
  
}