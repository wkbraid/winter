// file: actor.dart
// contains: Edges, Actor, Being

part of common;

class Edges {
  // Keeps track of the most recent tiles on the edges of the actor
  List up = [];
  List down = [];
  List left = [];
  List right = [];
}

class Actor {
  // Base class for all map dwellers
  
  Instance instance; // The instance the actor is part of
  
  bool team;
  
  num x,y; // Actor position in map coordinates
  num width = 10, height = 10; // Actor dimensions
  Edges edges = new Edges();
  String color = "red"; // Simple description needed to draw the actor
  
  bool dead = false; // Is the actor dead?
  
  num vx = 0; num vy = 0; // Actor velocity
  
  Point lastSolid = new Point(0,0); // The last place we were standing on something solid
  
  Actor(this.x,this.y); // Create a default actor at the given position 
 
  
  void interact(Hero hero){ } // Called when the hero tries to interact with the actor
  
  void collide(Actor other) { } // Called when the actor collides with other
  
  void update(dt) {
    vy += g*dt; // gravity
    // friction
    if (!edges.down.contains(Tile.ICE))
      vx *= pow(mu,dt); // ice has no friction
    vy *= pow(mu,dt);
    move(vx,vy); // move the enemy
  }
  
  // default functions
  void move(num dx, num dy) { // move the actor by dx,dy
    lookHorz(dx); // Refresh the edges
    lookVert(dy);
    dx = collideX(dx); // collide horizontally
    dy = collideY(dy); // collide vertically
    
    x += dx; // move the hero
    y += dy;
  }
  
  num collideX(num dx) { // check for collisions in the x direction
    if (dx < 0 && Tile.solid(edges.left)) {
      x = ((x+dx-width/2) ~/ ts)*ts + ts + width/2;
      vx = 0;
      return 0; // how much further we should move
    } else if (dx > 0 && Tile.solid(edges.right)) {
      x = ((x+dx+width/2) ~/ ts)*ts - width/2 - 0.001;
      vx = 0;
      return 0; // how much further we should move
    }
    return dx; // No collision
  }
  num collideY(num dy) { // check for collisions in the y direction
    if (dy < 0 && Tile.solid(edges.up)) {
      y = ((y+dy-height/2) ~/ ts)*ts + ts + height/2;
      vy = 0;
     return 0; // how much further we should move
    } else if (dy > 0 && (Tile.solid(edges.down) || edges.down.contains(Tile.CLOUD))) {
      y = ((y+dy+height/2) ~/ ts)*ts - height/2 - 0.001;
      vy = 0;
      return 0; // how much further we should move
    }
    return dy; // No collision
  }
  
  
  void lookVert(num dy) { // Refresh the tiles along the top and bottom of the actor
    edges.up = []; // reset edges
    edges.down = [];
    for (num xpos = x - width/2; xpos < x + width/2; xpos += ts) {
      edges.up.add(instance.map.get(xpos, y+dy-height/2));
      edges.down.add(instance.map.get(xpos, y+dy+height/2));
    }
    edges.up.add(instance.map.get(x+width/2, y+dy-height/2));
    edges.down.add(instance.map.get(x+width/2, y+dy+height/2));
  }
  void lookHorz(num dx) { // Refresh the tiles along the sides of the actor
    edges.left = []; //reset edges
    edges.right = [];
    for (num ypos = y - height/2; ypos < y + height/2; ypos += ts/2) {
      edges.left.add(instance.map.get(x+dx-width/2,ypos));
      edges.right.add(instance.map.get(x+dx+width/2,ypos));
    }
    edges.left.add(instance.map.get(x+dx-width/2,y+height/2));
    edges.right.add(instance.map.get(x+dx+width/2,y+height/2));
  }
  
  // ==== PACKING ====
  Actor.fromPack(data) {
    unpack(data);
  }
  pack() {
    return {
      "x": x, "y": y,
      "width": width, "height": height,
      "color": color,
      "vx" : vx, "vy": vy
    };
  }
  unpack(data) {
    x = data["x"]; y = data["y"];
    width = data["width"]; height = data["height"];
    color = data["color"];
    vx = data["vx"]; vy = data["vy"];
  }
}

class Being extends Actor {
  
  List<Buff> buffs = []; // Buffs currently affecting this being
      // should be made into a heap eventually probably
  
  Map<String,Spell> spells = {}; // The spells which can be cast by this being
  
  Stats base = new Stats(); // The being's base stats
  Stats get stats => base; // get the being's stats
  
  num mp,hp; // mana and health points

  // targetting
  num aimx, aimy;
  Being target;
  
  Being(x,y,this.base) : super(x,y){
    hp = stats.hpmax; // start with full hp/mp
    mp = stats.mpmax;
  }
  
  void update(dt) {
    super.update(dt);
    buffs.removeWhere((buff) => buff.duration <= 0); // clear finished buffs
    for (Buff buff in buffs) { // update buffs
      buff.update(dt);
    }
  }
  
  num collideY(dy) {
    if (Tile.solid(edges.down) || edges.down.contains(Tile.CLOUD))
      lastSolid = new Point(x,y); // remember this spot as a solid place
    return super.collideY(dy);
  }
  
 
  // ==== PACKING ====
  // Client should not get all data
  Being.fromPack(data) : super.fromPack(data) {
    unpack(data);
  }
  pack() {
    var data = super.pack();
    data["hp"] = hp;
    data["mp"] = mp;
    data["stats"] = stats.pack();
    data["being"] = true; // tell the instance that this is a being
    return data;
  }
  unpack(data) {
    mp = data["mp"];
    hp = data["hp"];
    base.unpack(data["stats"]);
    super.unpack(data);
  }
}