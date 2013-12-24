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

  void draw() {
    var ctx = stage.view.viewcontext;
    ctx.fillStyle = "red";
    ctx.strokeStyle = "darkred";
    ctx.fillRect(x-hp/10, y-8-height/2, hp/5, 5);
    ctx.lineWidth = 1;
    ctx.strokeRect(x-hp/10,y-8-height/2,hp/5,5);
    
    super.draw(); // draw the enemy body
  }
  void collide(Actor other) {
    if (other is Hero) // attack the hero
      other.hp -= 1;
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

class ShootyEnemy extends RandEnemy {
  // Like randomenemy, but shoots at the mouse position
  ShootyEnemy(x,y,stage) : super(x,y,stage) {
    spells = {
      "pellet" : new PelletSpell(this)
    };
    mpmax = 30;
    mp = mpmax;
  }
  void update() {
    super.update();
    spells["pellet"].cast(); // just blindly cast the pellet
    if (mp < mpmax) {
      mp++;
    }
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

