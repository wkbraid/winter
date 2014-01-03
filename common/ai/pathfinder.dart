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

  PathEnemy act;
  GameMap map; // The map we are traversing
  
  PathFinder(this.act) {
    map = act.instance.map;
  }
  
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
      if (!Tile.solid(map.getT(cur.x+dx,cur.y)))
        que.add(new PathAction(cur.x+dx,cur.y,PathAction.WALK,dist:cur.dist+1,parent:cur));
    }
  }
  
  // Try all possible fall moves from the current position (and add them to the que)
  void fall(PathAction cur, PriorityQueue<PathAction> que) {
    // assume vy starts at zero at the beginning of any fall
    // s = ut + 1/2 at^2 => t = sqrt(2s/a)
    
    num speed = 1.2; // Should be in pixels per millisecond (but maybe not)
    
    for (int dy = 1; dy + cur.y < mheight; dy ++) { // check rows below the player
      // Check the valid row of blocks beneath us
      
      num rng = sqrt(2*dy*ts/g)*speed ~/ ts; // the range of blocks accessible
      for (int dx = -rng; dx <= rng; dx++) {
        if (Tile.solid(map.getT(cur.x+dx,cur.y+dy+1))
            && !solidRect(cur.x,cur.y,cur.x+dx,cur.y+dy)) {
          // there is a valid landing zone
          que.add(new PathAction(cur.x+dx,cur.y+dy,PathAction.FALL,
              dist:cur.dist+dx.abs()+dy,parent:cur));
        }
      }
    }
  }
  
  // check if there are any solid blocks in the rectangle
  bool solidRect(int x1, int y1, int x2, int y2) {
    if (x1 > x2) return solidRect(x2,y1,x1,y2); // make sure our rectangle is well orientated
    if (y1 > y2) return solidRect(x1,y2,x2,y1);
    for (int i = x1; i <= x2; i++) {
      for (int j = y1; j <= y2; j++) {
        if (Tile.solid(map.getT(i, j))) return true;
      }
    }
    return false;
  }
  
  // Try all possible fall moves from the current position (and add them to the que)
  void jump(PathAction cur, PriorityQueue<PathAction> que) {
    if (!Tile.solid(map.getT(cur.x,cur.y+1))) return; // Need to be standing on something solid
    
    // This requires two steps:
    // (1) Find t, time to reach height dy*h
    //    s=ut + 1/2at^2
    //   using quadratic formula:
    //    t = -u - sqrt(u^2 -as)
    // (2) Find rng, horz distance travellable in that time
    //    rng = t*speed
    
    num speed = 500;
    int jumph = -4;
    
    // current problem: since lower jumps are checked we start falls with vy
    
    for (int dy = jumph; dy <= 0; dy++) { // look upwards
      num rng = ((act.jv - sqrt(act.jv*act.jv - g*dy.abs()*ts))*speed) ~/ ts;
      for (int dx = -rng; dx <= rng; dx ++) {
        // either this is a max jump or we hit our head
        if (dy == jumph || Tile.solid(map.getT(cur.x+dx,cur.y+dy-1))) {
          if (!solidRect(cur.x,cur.y,cur.x+dx,cur.y+dy)) { // if there is nothing in the way
            que.add(new PathAction(cur.x+dx,cur.y+dy,PathAction.JUMP,
                dist: cur.dist+dy.abs()+dx.abs(), parent: cur));
          }
        }
      }
    }
  }
}