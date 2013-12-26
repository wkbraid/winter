// file: actor.dart
part of common;


class Actor extends Sync {
  // Base class for all map dwellers
  
  GameMap map; // The map the actor is on
  
  num x,y; // Actor position in map coordinates
  num width,height; // Actor dimensions
  String color; // Simple description needed to draw the actor
  bool down = false; // Is there something below the map
  
  num vx = 0; num vy = 0; // Actor velocity
  
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
  
  // packing
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

class Player extends Actor {
  // Represents a player character on either the server or the client,
  // Clients extend player with the class Hero to differentiate their own hero
  
  String name; // The name of the character the hero represents
  Stats stats; // The player's statistics
  
  Player(); // Create an empty player
  
  // Create a player representing a character, should only be used by the server
  Player.fromChar(Character char, GameMap map) {
    this.map = map;
    name = char.name;
    x = char.x;
    y = char.y;
    stats = char.stats;
    width = 20;
    height = 20;
    color = "lightgreen";
  }
  
  // packing
  Player.fromPack(data) {
    unpack(data);
  }
  pack() {
    // TODO: hmmm to sync the map or not? we don't want to, but player wants access to it
    var data = super.pack();
    data["name"] = name;
    return data;
  }
  unpack(data) {
    name = data["name"];
    super.unpack(data);
  }
}

class Stats extends Sync {
  // Class for holding statistics, used by hero/items/buffs
  num hp,hpmax,mp,mpmax,jump,speed; // all of the stats
  Stats({this.hp:0,this.hpmax:0,this.mp:0,this.mpmax:0,this.jump:0,this.speed:0}); // everything is zero by default
  Stats operator+(Stats other) { // add the stats together and return a new Stats object
    Stats result = new Stats();
    result.hp = hp + other.hp; // it would be nice to find a more compact way of doing this
    result.hpmax = hpmax + other.hpmax;
    result.mp = mp + other.mp;
    result.mpmax = mpmax + other.mpmax;
    result.jump = jump + other.jump;
    result.speed = speed + other.speed;
    return result;
  }
  
  // stats are equal if all of their internal components are equal
  int get hashCode => hp.hashCode+2*hpmax.hashCode+3*mp.hashCode+5*mpmax.hashCode+7*jump.hashCode+11*speed.hashCode;
  bool operator==(other) =>
      hp == other.hp && hpmax == other.hpmax
      && mp == other.mp && mpmax == other.mpmax
      && jump == other.jump && speed == other.speed;
  
  // packing
  Stats.fromPack(data) {
    hp = data["hp"]; hpmax = data["hpmax"];
    mp = data["mp"]; mpmax = data["mpmax"];
    jump = data["jump"]; speed = data["speed"];
  }
  pack() {
    return {
      "hp" : hp, "hpmax" : hpmax,
      "mp" : mp, "mpmax" : mpmax,
      "speed" : speed, "jump" : jump
    };
  }
  unpack(data) {
    hp = data["hp"]; hpmax = data["hpmax"];
    mp = data["mp"]; mpmax = data["mpmax"];
    jump = data["jump"]; speed = data["speed"];
  }
}