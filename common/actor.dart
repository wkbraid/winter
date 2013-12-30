// file: actor.dart
part of common;

class Edges {
  // Keeps track of the most recent tiles on the edges of the hero
  List up = [];
  List down = [];
  List left = [];
  List right = [];
}

class Actor extends Sync {
  // Base class for all map dwellers
  
  GameMap map; // The map the actor is on
  
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
      x = ((x+dx-width/2) ~/ map.ts)*map.ts + map.ts + width/2;
      vx = 0;
      return 0; // how much further we should move
    } else if (dx > 0 && Tile.solid(edges.right)) {
      x = ((x+dx+width/2) ~/ map.ts)*map.ts - width/2 - 0.001;
      vx = 0;
      return 0; // how much further we should move
    }
    return dx; // No collision
  }
  num collideY(num dy) { // check for collisions in the y direction
    if (dy < 0 && Tile.solid(edges.up)) {
      y = ((y+dy-height/2) ~/ map.ts)*map.ts + map.ts + height/2;
      vy = 0;
     return 0; // how much further we should move
    } else if (dy > 0 && (Tile.solid(edges.down) || edges.down.contains(Tile.CLOUD))) {
      y = ((y+dy+height/2) ~/ map.ts)*map.ts - height/2 - 0.001;
      vy = 0;
      return 0; // how much further we should move
    }
    return dy; // No collision
  }
  
  
  void lookVert(num dy) { // Refresh the tiles along the top and bottom of the actor
    edges.up = []; // reset edges
    edges.down = [];
    for (num xpos = x - width/2; xpos < x + width/2; xpos += map.ts) {
      edges.up.add(map.get(xpos, y+dy-height/2));
      edges.down.add(map.get(xpos, y+dy+height/2));
    }
    edges.up.add(map.get(x+width/2, y+dy-height/2));
    edges.down.add(map.get(x+width/2, y+dy+height/2));
  }
  void lookHorz(num dx) { // Refresh the tiles along the sides of the actor
    edges.left = []; //reset edges
    edges.right = [];
    for (num ypos = y - height/2; ypos < y + height/2; ypos += map.ts/2) {
      edges.left.add(map.get(x+dx-width/2,ypos));
      edges.right.add(map.get(x+dx+width/2,ypos));
    }
    edges.left.add(map.get(x+dx-width/2,y+height/2));
    edges.right.add(map.get(x+dx+width/2,y+height/2));
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
      buff.update(dt);
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
    
    target = this; // target yourself
    
    spells = {
      "pellet" : new PelletSpell(this),
      "poison" : new PoisonSpell(this)
    }; 
  }
  
  void update(num dt) {
    if (hp < 0) {
      print("$name is dead.");
      hp = stats.hpmax;
    }
    aimx = input["mousex"]; // aim at the mouse position
    aimy = input["mousey"];
    vx += (input["right"] - input["left"])*stats.speed*dt;
    if (edges.up.contains(Tile.LADDER) && input["up"] > 0) {
      vy -= stats.speed*dt*5 + g*dt; // move upwards countering gravity
    } else if (vy >= 0 && (Tile.solid(edges.down) || edges.down.contains(Tile.CLOUD)) && input["up"] > 0) {
      vy -= stats.jump;
    }
    
    if (input["mousedown"]) {
      spells["pellet"].cast();
    }
    
    mp += dt/100;
    mp.clamp(0, stats.mpmax); // restrict mp from being greater than mpmax
    
    super.update(dt);
  }
  
  void collide(Actor other) {
    if (other is Pickupable && input["down"] != 0) {
      other.dead = inv.put(other.item); // pick up the item
      if (other.item is Equipable)
        inv.equip(other.item); // equip it right away
    } else if (other is Portal && input["down"] != 0) {
      other.open(this);
    }
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
  packRest() { // Pack up semi-secret data to be saved in the database, or sent to the client who owns the hero
    var data = pack();
    data["inv"] = inv.pack();
    return data;
    }
  unpackRest(data) { // unpack semi-secret data
    inv.unpack(data["inv"]);
    unpack(data);
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

class Inventory {
  // the hero's inventory
  // HOW IT WORKS:
  // The inventory is divided into two parts: equipment and backpack
  // Equipment holds one item for each item slot defined by Equipable.TYPE
  // Backpack will hold all unequipped items
  // The backpack will endlessly stack any items defined to be identical by their hashCode function
  
  List<Equipable> equipment = new List(6); // equipped items
  Map<Item,int> backpack = {}; // unequipped items
  
  Stats get stats => // get the stat bonus from the inventory
    equipment.fold(new Stats(), (acc,item) {
        if (item != null)
          return acc + item.stats;
        else
          return acc;
    });
  
  bool equip(Equipable item) {
    if (equipment[item.type] == null || unequip(equipment[item.type])) { // is the equipment slot free?
      if (take(item)) { // take the item from the backpack
        equipment[item.type] = item; // equip the item
        return true;
      }
    }
    return false; // might also fail later if some items are non-equipable
  }
  
  bool unequip(Equipable item) {
    if (put(item)) {
      equipment[item.type] = null; // unequip the item
      return true;
    }
    return false;
  }
  
  bool take(Item item, {num count : 1}) { // take an item from the backpack
    if (backpack[item] > count)
      backpack[item] -= count;
    else if (backpack[item] == count)
      backpack.remove(item);
    else
      return false; // not enough items to take
    return true; // otherwise we succeeded
  }
  bool put(Item item, {num count : 1}) { // put an item into the backpack
    if (backpack.containsKey(item))
      backpack[item] += count;
    else
      backpack[item] = count;
    return true; // for now always succeeds, might later fail if backpack is full
  }
  
  // ==== PACKING ====
  pack() {
    var data = {};
    data["equipment"] = [];
    var tmp = equipment.toList();
    for (Equipable item in tmp) {
      if (item != null)
        data["equipment"].add(item.pack());
    }
    
    tmp = backpack.keys.toList(); // take a copy for concurrency
    data["backpack"] = [];
    for (Item item in tmp) { // pack up the backpack
      data["backpack"].add({"key":item.pack(),"value":backpack[item],"equipable": item is Equipable});
    }
    return data;
  }
  unpack(data) {
    equipment = new List(6);
    for (var itemd in data["equipment"]) {
      Equipable item = new Equipable.fromPack(itemd);
      equipment[item.type] = item;
    }
    backpack = {}; // expensively overwrite backpack
    for (var kvpair in data["backpack"]) {
      if (kvpair["equipable"]) // TODO find a better way to do this
        backpack[new Equipable.fromPack(kvpair["key"])] = kvpair["value"];
      else
        backpack[new Item.fromPack(kvpair["key"])] = kvpair["value"];
    }
  }
}