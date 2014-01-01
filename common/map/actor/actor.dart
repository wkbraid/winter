// file: actor.dart
// contains: Edges, Actor, Being, Hero

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
  
  num x,y; // Actor position in map coordinates
  num width = 10, height = 10; // Actor dimensions
  Edges edges = new Edges();
  String color = "red"; // Simple description needed to draw the actor
  
  bool dead = false; // Is the actor dead?
  
  num vx = 0; num vy = 0; // Actor velocity
  
  Actor(this.x,this.y); // Create a default actor at the given position 
 
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
  
  void interact(Hero hero){
    return;
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
  
 
  // ==== PACKING ====
  // Client should not get all data
  Being.fromPack(data) : super.fromPack(data) {
    unpack(data);
  }
  pack() {
    var data = super.pack();
    data["hp"] = hp;
    data["mp"] = mp;
    return data;
  }
  unpack(data) {
    mp = data["mp"];
    hp = data["hp"];
    super.unpack(data);
  }
}


class Hero extends Being {
  // Represents a player character on the server
  // Only some of the information stored is made publically available

  String name; // The name of the character this hero represents
  String mapid; // The map the hero is currently on
  num overlay;
  
  // Inventory inv; // The hero's inventory

  Stats get stats => base + inv.stats + buffs.fold(new Stats(), (acc,buff) => acc + buff.stats);
  
  Inventory inv = new Inventory(); // The hero's inventory
  
  // most recent input information from the client
  dynamic input = {"up":0,"down":0,"left":0,"right":0,
                   "mousex":0,"mousey":0,
                   "mousedown":false}; 
  
  Hero(this.name,x,y,this.mapid,base) : super(x,y,base) {
    width = 20;
    height = 20;
    color = "lightgreen";
    overlay = 0;
    
    target = this; // target yourself
    
    spells = {
      "pellet" : new PelletSpell(this),
      "poison" : new PoisonSpell(this)
    }; 
  }
  
  void update(num dt) {
    if(overlay == 0){
      if (hp < 0) {
        print("$name is dead.");
        hp = stats.hpmax;
      }
      aimx = input["mousex"]; // aim at the mouse position
      aimy = input["mousey"];
      vx += (input["right"] - input["left"])*stats.speed*dt;
      if (edges.up.contains(Tile.LADDER) && input["up"] > 0) {
        vy -= stats.speed*dt*5 + g*dt; // move upwards countering gravity
      } else if (vy >= 0 && (Tile.solid(edges.down) || edges.down.contains(Tile.CLOUD)) 
          && !Tile.solid(edges.up) && input["up"] > 0) {
        vy -= stats.jump;
      }
      
    
      if (input["mousedown"]) {
        spells["pellet"].cast();
      }
  
      if(mp < stats.mpmax)
        mp += dt/stats.mpmax; // replenish mp
      if(mp > stats.mpmax) // make sure hp is never above hpmax
        mp = stats.mpmax;
      if(hp > stats.hpmax)
        hp = stats.hpmax; // make sure mp is never above mpmax
    }
    else{
      if(input["up"] != 0)
        overlay = 0;
    }
    super.update(dt);
  }
  
  //Calls on nearby actors' interact function if pressing down and touching them.
  void collide(Actor other) {
    if (input["down"] != 0){
      print("made it");
      other.interact(this);
    }
  }
//old collide code in case we need it
 // if (other is Pickupable && input["down"] != 0) {
 //   other.dead = inv.put(other.item); // pick up the item
 //   if (other.item is Equipable)
 //     inv.equip(other.item); // equip it right away
 // } else if (other is Portal && input["down"] != 0) {
 //   other.interact(this);
 // }
//}
  
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
  packRest() { // Pack up semi-secret data to be saved in the database, or sent to the client who owns the hero
    var data = pack();
    data["inv"] = inv.pack();
    data["base"] = base.pack();
    data["buffs"] = buffs.map((buff) => buff.pack()).toList();
    data["overlay"] = overlay;
    return data;
    }
  unpackRest(data) { // unpack semi-secret data
    inv.unpack(data["inv"]);
    base.unpack(data["base"]);
    buffs = data["buffs"].map((buffd) => new Buff.fromPack(buffd)).toList();
    unpack(data);
    overlay = data["overlay"];
    }
}