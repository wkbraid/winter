// file: mobspawner.dart
// contains: MobSpawner

part of common;

class MobSpawner {
  // Spawns mobs for a map segment
  
  GameMap map; // The map this mob spawner is spawning for
  
  List spawners; // A list of anonymous functions which produce enemies of different types
  int interval; // The interval at which we should spawn mobs
  
  MobSpawner(this.interval, this.spawners);
  
  void start() { // start spawning mobs
    if (spawners.length > 0) // only if we have something to spawn
      new Timer(new Duration(milliseconds:interval), spawn);
  }
  
  void spawn() {
    Point pos = choosePosition();
    List<Enemy> enemies = spawners.map((spawner) => spawner()).toList(); // take one of each for now
    Mob mob = new Mob(pos.x,pos.y,enemies);
    map.addActor(mob);
    new Timer(new Duration(milliseconds:interval), spawn);
  }
  
  Point choosePosition() {
    return new Point(150,150);
  }
}