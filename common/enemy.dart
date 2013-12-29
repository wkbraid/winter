// file: enemy.dart
part of common;

class Enemy extends Being {
  // Basic enemy class, abstracts most functionality other than AI decisions
  
  Enemy(x,y,base) : super(x,y,base) {
    color = "orange"; // drawing colors
    target = this; // default target self
  }
  
  void update(dt) {
    if (hp <= 0) dead = true; // check if the enemy is dead
    
    /*
    // targeting
    posx = this.x;
    posy = this.y;
    aimx = stage.hero.x; // default target at hero -- add possibility to target at allies/different heroes later
    aimy = stage.hero.y;
    */
    super.update(dt);
  }

  void collide(Actor other) {
    if (other is Hero) {// attack the hero
      other.hp -= 1;
      print("We hit a hero");
    }
  }
  //==== PACKING ====
  // Client does not need to know anything special about enemies
  Enemy.fromPack(data) : super.fromPack(data);
}

//=============================================
// Game Enemies
//=============================================


class RandEnemy extends Enemy {
  // Basic enemy with randomized movement
  RandEnemy(x,y,base) : super(x,y,base) {
    width = 20;
    height = 20;
  }
  void update(dt) {
    // decide whether we should randomly jump
    var rand = new Random();
    if (rand.nextDouble() < 0.01 && down)
      vy -= 18;
    // now decide which way we should push
    if (vx.abs() < 1)
      vx += (rand.nextDouble() - 0.5)*dt;
    else
      vx += vx/1400*dt;
    
    super.update(dt); // physics and move the enemy
  }
}