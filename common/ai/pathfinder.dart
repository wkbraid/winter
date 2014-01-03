// file: pathfinder.dart
// contains: PathAction, PathFinder

part of common;

class PathAction {
  // Represents one step along a macro path to travel
  
  // Types of movement (also used for prority, smaller first)
  static const SIT = 0; // Do nothing and we're there
  static const WALK = 1;
  static const FALL = 2;
  static const JUMP = 3;
  
  Point pos; // The position of the action in tile coords
  int get x => pos.x;
  int get y => pos.y;
  int type; // Type of the action from movement types above
  
  int dist; // How far along the path this action is (using in A* sort)
  
  PathAction _parent;
  
  PathAction(int x, int y,this.type, {this.dist : 0, parent}) {
    pos = new Point(x,y);
    _parent = parent;
  }
  
  String toString() { // easier printing
    return "{x: $x, y: $y, dist: $dist, type: $type}";
  }
  
  List<PathAction> toList() {
    // Convert the recursive chain of PathActions to a list, starting with the 'first' parent
    if (_parent == null) return [];
    else {
      List<PathAction> sum = _parent.toList();
      sum.add(this); // Add ourselves to the end of the chain
      return sum;
    }
  }
}

class PathFinder {
  // Handles basic macro pathfinding techniques

  GameMap map; // The map we are traversing
  
  PathFinder(this.map);
  
  // Find a path from src to targ
  List<PathAction> find(Point src, Point trg) {
    PriorityQueue<PathAction> que = new PriorityQueue(
        comparator: (pa1, pa2) { // A* search using discreet distance
            int dist1 = pa1.dist + (pa1.x - trg.x).abs() + (pa1.y - trg.y).abs();
            int dist2 = pa2.dist + (pa2.x - trg.x).abs() + (pa2.y - trg.y).abs();
            if (dist1.compareTo(dist2)== 0) // equal distance
              return -pa1.type.compareTo(pa2.type); // secondart order by type
            else
              return -dist1.compareTo(dist2); // negate so that shorter distances are closer to max
        }
    );
    Set<Point> visited = new Set(); // The set of visited points
    
    que.add(new PathAction(src.x,src.y,PathAction.SIT)); // Add the starting point to the queue
    
    while(que.isNotEmpty) { // go through the que
      PathAction cur = que.removeMax();
      if (!visited.contains(cur.pos)) { // don't revisit positions
        visited.add(cur.pos); // Add the current position to the set of visited nodes
        if (cur.pos == trg)
          return cur.toList(); // we reached our destination
        
        // try walking
        walk(cur, que);
        
        // try falling
        fall(cur, que);
        
        // try jumping
        jump(cur, que);
      }
    }
    return []; // We couldn't reach the point
  }
  
  // Try all possible walk moves from the current position (and add them to the que)
  void walk(PathAction cur, PriorityQueue<PathAction> que) {
    if (!Tile.solid(map.getT(cur.x,cur.y+1))) return; // Need to be standing on something solid

    // left and right
    for (int dx = -1; dx <= 1; dx += 2) {
      if (!Tile.solid(map.getT(cur.x+dx,cur.y)) && Tile.solid(map.getT(cur.x+dx,cur.y+1)))
        que.add(new PathAction(cur.x+dx,cur.y,PathAction.WALK,dist:cur.dist+1,parent:cur));
    }
  }
  
  // Try all possible fall moves from the current position (and add them to the que)
  void fall(PathAction cur, PriorityQueue<PathAction> que) {

    // currently fall directly down only
    // fall either left or right
    for (int dx = -1; dx <= 1; dx += 2) {
      if (!Tile.solid(map.getT(cur.x+dx,cur.y)) &&
          !Tile.solid(map.getT(cur.x+dx, cur.y+1))) { // we can move in that direction
        // check downwards, void means we checked all the way to the bottom of the map
        for (int dy = 1; map.getT(cur.x+dx, cur.y+dy+1) != Tile.VOID; dy += 1) {
          if (Tile.solid(map.getT(cur.x+dx, cur.y+dy+1))) {
            que.add(new PathAction(cur.x+dx,cur.y+dy,PathAction.FALL,
                dist:cur.dist+dx.abs()+dy,parent:cur));
            break; // we hit the bottom of something
          }
        }
      }
    }
  }
  
  // Try all possible fall moves from the current position (and add them to the que)
  void jump(PathAction cur, PriorityQueue<PathAction> que) {
    if (!Tile.solid(map.getT(cur.x,cur.y+1))) return; // Need to be standing on something solid
    
    // currently jump straight up a fixed distance and then fall
    int jumph = -4; // jump up to 4 blocks
    for (int dy = 0; dy >= jumph; dy--) {
      if (Tile.solid(map.getT(cur.x, cur.y+dy-1)) || dy == jumph) { // we would hit something
        que.add(new PathAction(cur.x,cur.y+dy,PathAction.JUMP,
            dist: cur.dist+dy.abs(), parent: cur));
        break;
      }
    }
  }
}