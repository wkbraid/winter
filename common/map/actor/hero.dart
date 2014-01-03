// file: hero.dart
// contains: Hero

part of common;

class Hero extends Being {
  // Represents a player character on the server
  // Only some of the information stored is made publically available

  String name; // The name of the character this hero represents
  String mapid; // The map the hero is currently on
  num overlay;

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
      } else if (vy >= 0 && (Tile.anysolid(edges.down) || edges.down.contains(Tile.CLOUD)) 
          && !Tile.anysolid(edges.up) && input["up"] > 0) {
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