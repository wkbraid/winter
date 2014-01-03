// file: enemies.dart
// contains: PathEnemy, RandEnemy

part of common;

//=============================================
// Game Enemies
//=============================================

class PathEnemy extends Enemy {
  // Simple Enemy, follows paths found by PathFinder
  List<PathAction> path = [];
  
  PathEnemy(x,y,base) : super(x,y,base) {
    width = ts - 1;
    height = ts - 1;
  }
  
  void update(dt) {
    vx = 0;
    if (path.isNotEmpty) {
      PathAction next = path.first;
      if (x.round() == next.x*ts + ts/2 && y ~/ ts == next.y) { // currently need to reach node exactly
        path.removeAt(0); // move onto the next node
        update(dt);
        return;
      }
      if (next.type == PathAction.WALK || next.type == PathAction.FALL) {
        vx = (next.x*ts + ts/2 - x)*(dt/10)/(next.x*ts + ts/2 - x).abs();
        vx = (next.x*ts + ts/2 - x).abs() > vx.abs() ? vx : next.x*ts + ts/2 - x; // if we are close move there exactly
      } else if (next.type == PathAction.JUMP && Tile.anysolid(edges.down)) {
        vy -= 22;
      }
    }
    vy += g*dt;
    move(vx,vy);
  }
}

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