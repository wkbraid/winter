// file: enemies.dart
// contains: PathEnemy, RandEnemy

part of common;

//=============================================
// Game Enemies
//=============================================

class PathEnemy extends Enemy {
  // Simple Enemy, follows paths found by PathFinder
  List<PathAction> path = [];
  
  num jv = 22; // initial jump velocity
  
  PathEnemy(x,y,base) : super(x,y,base) {
    width = ts - 1;
    height = ts - 1;
  }
  
  void update(dt) {
    vx = 0;
    
    // NB: if it gets off its path it is useless
    if (path.isNotEmpty) {
      PathAction next = path.first;
      if (y ~/ ts > next.y && next.type != PathAction.JUMP) {
        // We are probably off course
        print("We're lost!");
      }
      
      if (x.round() == next.x*ts + ts/2 && y ~/ ts == next.y) { // currently need to reach node exactly
        path.removeAt(0); // move onto the next node
        return;
      } else if (x.round() == (next.x*ts + ts/2) && y < next.y*ts + ts/2 && next.type == PathAction.JUMP) {
        // we jumped above the goal
        path.removeAt(0);
        return;
      }
      vx = (next.x*ts + ts/2 - x)*(dt/6)/(next.x*ts + ts/2 - x).abs();
      vx = (next.x*ts + ts/2 - x).abs() > vx.abs() ? vx : next.x*ts + ts/2 - x; // if we are close move there exactly
      if (next.type == PathAction.JUMP && Tile.anysolid(edges.down)) {
        vy -= jv;
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