// file: enemies.dart
// contains: PathEnemy, RandEnemy

part of common;

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
    if (rand.nextDouble() < 0.01 && edges.down.contains(Tile.WALL))
      vy -= 18;
    // now decide which way we should push
    if (vx.abs() < 1)
      vx += (rand.nextDouble() - 0.5)*dt;
    else
      vx += vx/1400*dt;
    
    super.update(dt); // physics and move the enemy
  }
}