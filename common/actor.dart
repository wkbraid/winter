// file: actor.dart
part of common;


class Actor extends Sync {
  // Base class for all map dwellers
  num x,y; // Actor position in map coordinates
  num width,height; // Actor dimensions
  String color; // Simple description needed to draw the actor
  
  num vx = 0; num vy = 0; // Actor velocity
  
  void update(dt) {
    //vy += g*dt; // gravity
    vx *= pow(mu,dt); // friction
    vy *= pow(mu,dt);
    move(vx,vy); // move the enemy
  }
  
  void move(num dx,num dy) {
    x += vx;
    y += vy;
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
  
  Player(); // Create an empty player
  
  // Create a player representing a character, should only be used by the server
  Player.fromChar(Character char) {
    x = char.x;
    y = char.y;
    width = 20;
    height = 20;
    color = "lightgreen";
  }
  Player.fromPack(data) {
    unpack(data);
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