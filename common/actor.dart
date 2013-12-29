// file: actor.dart
part of common;


class Actor extends Sync {
  // Base class for all map dwellers
  
  GameMap map; // The map the actor is on
  
  num x,y; // Actor position in map coordinates
  num width = 10, height = 10; // Actor dimensions
  String color = "red"; // Simple description needed to draw the actor
  
  bool dead = false; // Is the actor dead?
  bool down = false; // Is there something below the map
  
  num vx = 0; num vy = 0; // Actor velocity
  
  Actor(this.x,this.y); // Create a default actor at the given position 
 
  void collide(Actor other) { } // Called when the actor collides with other
  
  void update(dt) {
    vy += g*dt; // gravity
    vx *= pow(mu,dt); // friction
    vy *= pow(mu,dt);
    move(vx,vy); // move the enemy
  }
  
  // default functions
  void move(num dx, num dy) { // move the actor by dx,dy
    down = false; // reset the ground status
    
    if (dx > 0 && sumHorz(x+dx+width/2) != 0)
      dx = collideX(dx); // collide right
    if (dx < 0 && sumHorz(x+dx-width/2) != 0)
      dx = collideX(dx); // collide left
    
    if (dy > 0 && sumVert(y+dy+height/2) != 0)
      dy = collideY(dy);
    if (dy < 0 && sumVert(y+dy-height/2) != 0)
      dy = collideY(dy);
    
    x += dx; // move the hero
    y += dy;
  }
  num collideX(num dx) { // collide with a wall in the x direction
    if (dx < 0)
      x = ((x+dx-width/2) ~/ map.ts)*map.ts + map.ts + width/2;
    else
      x = ((x+dx+width/2) ~/ map.ts)*map.ts - width/2 - 0.001;
    vx = 0;
    return 0;
  }
  num collideY(num dy) { // collide with a wall in the y direction
    if (dy > 0) down = true; // there is something below us
    if (dy < 0)
      y = ((y+dy-height/2) ~/ map.ts)*map.ts + map.ts + height/2;
    else
      y = ((y+dy+height/2) ~/ map.ts)*map.ts - height/2 - 0.001; 
    vy = 0;
    return 0;
  }
  
  // sum over the map coordinates along the ypos along the edge along the width of the actor
  num sumVert(ypos) {
    num sum = 0;
    for (num xpos = x - width/2; xpos < x + width/2; xpos += map.ts/2) {
      sum += map.get(xpos, ypos);
    }
    return sum + map.get(x + width/2, ypos);
  }
  
  // sum over the map coordinates along the xpos along the edge along the height of the actor
  num sumHorz(xpos) {
    num sum = 0;
    for (num ypos = y - height/2; ypos < y + height/2; ypos += map.ts/2) {
      sum += map.get(xpos, ypos);
    }
    return sum + map.get(xpos,y+height/2);
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
  
  Stats base; // The being's base stats
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
      buff.update();
    }
  }
  
  // ==== PACKING ====
  // Client should not get all data
  Being.fromPack(data) : super.fromPack(data);
}


class Hero extends Being {
  // Represents a player character on the server
  // Only some of the information stored is made publically available

  String name; // The name of the character this hero represents
  String mapid; // The map the hero is currently on
  
  // Inventory inv; // The hero's inventory

  Stats get stats => base; // + inv.stats + buffs.fold(new Stats(), (acc,buff) => acc + buff.stats);
  
  // most recent input information from the client
  dynamic input = {"up":0,"down":0,"left":0,"right":0,
                   "mousex":0,"mousey":0,
                   "mousedown":false}; 
  
  Hero(this.name,x,y,this.mapid,base) : super(x,y,base) {
    width = 20;
    height = 20;
    color = "lightgreen";
    
    spells = {
      "pellet" : new PelletSpell(this)
    }; 
  }
  
  void update(num dt) {
    aimx = input["mousex"]; // aim at the mouse position
    aimy = input["mousey"];
    vx += (input["right"] - input["left"])*stats.speed*dt;
    if (down && input["up"] > 0) vy -= stats.jump;
    down = false;
    
    if (input["mousedown"]) {
      spells["pellet"].cast();
    }
    
    mp += dt/100;
    mp.clamp(0, stats.mpmax); // restrict mp from being greater than mpmax
    
    super.update(dt);
  }
  
  // ==== PACKING ====
  Hero.fromPack(data) : super.fromPack(data) {
    unpack(data);
  }
  pack() {
    // Should only send data visible to all clients
    // Client specific data needed for spell casting etc will be sent separately.
    var data = super.pack(); // Pack the basics
    data["name"] = name;
    data["mapid"] = mapid;
    return data;
  }
  unpack(data) {
    name = data["name"];
    mapid = data["mapid"];
    super.unpack(data); // Unpack basics
  }
}

class Stats extends Sync {
  // Class for holding static statistics, used by hero/items/buffs
  num hp,hpmax,mp,mpmax,jump,speed; // all of the stats
  Stats({this.hpmax:0,this.mpmax:0,this.jump:0,this.speed:0}); // everything is zero by default
  Stats operator+(Stats other) { // add the stats together and return a new Stats object
    Stats result = new Stats();
    result.hpmax = hpmax + other.hpmax; // it would be nice to find a more compact way of doing this
    result.mpmax = mpmax + other.mpmax;
    result.jump = jump + other.jump;
    result.speed = speed + other.speed;
    return result;
  }
  
  // stats are equal if all of their internal components are equal
  int get hashCode => hpmax.hashCode+5*mpmax.hashCode+7*jump.hashCode+11*speed.hashCode;
  bool operator==(other) =>
      hpmax == other.hpmax && mpmax == other.mpmax
      && jump == other.jump && speed == other.speed;
  
  // packing
  Stats.fromPack(data) {
    hpmax = data["hpmax"]; mpmax = data["mpmax"];
    jump = data["jump"]; speed = data["speed"];
  }
  pack() {
    return {
      "hpmax" : hpmax, "mpmax" : mpmax,
      "speed" : speed, "jump" : jump
    };
  }
  unpack(data) {
    hpmax = data["hpmax"]; mpmax = data["mpmax"];
    jump = data["jump"]; speed = data["speed"];
  }
}