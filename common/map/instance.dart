// file: instance.dart
// contains: BattleInstance, Instance

part of common;

class BattleInstance extends Instance {
  // An instance of a map on which a battle is taking place
  
  Map<bool,List<Being>> teams = {true: [], false:[]};
  
  
}

class Instance {
  // Contains information about a specific instance of a GameMap
  
  GameMap map; // the map that this is an instance of
  
  bool open = true; // Is the current instance open?
  
  Map<String,Hero> heros = {}; // players on the map, accessed by character name
  List<Actor> actors = []; // All other actors on the map
  
  Instance(); // Create a new instance of a map
  
  void update(num dt) {
    var tmp = heros.values.toList(); // copy to stop concurrency issues
    for (Hero hero in tmp) {
      hero.update(dt); // update each player on the map
      if (hero.x > ts*mwidth) {
        if (map.right != null) {
          hero.x = ts*mwidth - hero.x;
          hero.mapid = map.right;
        } else {
          hero.x = ts*mwidth; // stop the hero falling off completely
          hero.vx = 0;
        }
      } else if (hero.x < 0) {
        if ( map.left != null) {
          hero.x = ts*mwidth + hero.x;
          hero.mapid = map.left;
        } else {
          hero.x = 0;
          hero.vx = 0;
        }
      }
      if (hero.y > ts*mheight) {
        if (map.down != null) {
          hero.y = ts*mheight - hero.y;
          hero.mapid = map.down;
        } else {
          hero.y = ts*mheight;
          hero.vy = 0;
        }
      } else if (hero.y < 0) {
        if (map.up != null) {
          hero.y = ts*mheight + hero.y;
          hero.mapid = map.up;
        } else {
          hero.y = 0;
          hero.vy = 0;
        }
      }
    }
    
    
    // remove the dead actors
    actors.removeWhere((act) => act.dead);
    tmp = actors.toList(); // take a copy for concurrency
    for (Actor act in tmp) { // update all other actors
      act.update(dt);
    }
    
    collide(); // check for collision
  }
  
  
  void collide() { // Check for and perform any collisions
    var tmpheros = heros.values.toList();
    var tmpactors = actors.toList();
    
    // Check heros for collisions
    for (int h = 0; h < tmpheros.length; h++) {
      for(Actor act in tmpactors) { // collide with actors
        if (collision(act,tmpheros[h])) {
          act.collide(tmpheros[h]);
          tmpheros[h].collide(act);
        }
      }
      for (int h2 = h+1; h2 < tmpheros.length; h2++) { // collide with all other heros
        if (collision(tmpheros[h],tmpheros[h2])) {
          tmpheros[h].collide(tmpheros[h2]);
          tmpheros[h2].collide(tmpheros[h]);
        }
      }
    }
    // Check actor-actor collisions
    for (int a = 0; a < tmpactors.length; a++) {
      for (int a2 = a+1; a2 < tmpactors.length; a2++) {
        if (collision(tmpactors[a],tmpactors[a2])) {
          tmpactors[a].collide(tmpactors[a2]);
          tmpactors[a2].collide(tmpactors[a]);
        }
      }
    }
  }
  
  bool collision(Actor act1, Actor act2) =>  // Check whether two actors collided
    act2.x - act2.width/2 < act1.x + act1.width/2
    && act2.x + act2.width/2 > act1.x - act1.width/2
    && act2.y - act2.height/2 < act1.y + act1.height/2
    && act2.y + act2.height/2 > act1.y - act1.height/2;
    
    
  // === Heros ===
  bool addHero(Hero hero) { // Add a player to the instance
    if (heros.containsKey(hero.name))
      print("Warning! Hero already on map");
    if (hero.instance != null) {
      hero.instance.removeHero(hero); // remove the hero from the old instance
    }
    heros[hero.name] = hero; // add the player to the instance
    hero.instance = this;
    return true; // Currently always succeeds
  }
  void removeHero(Hero hero) { // Remove a character from the instance by name
    heros.remove(hero.name);
  }
  
  // === Being ===
  bool addBeing(Being being) { // Beings could get slightly special treatment, (used in battles)
    addActor(being); // but not in default instances
  }
  
  // === Actors ===
  void addActor(Actor act) { // Add an actor to the map
    actors.add(act);
    act.instance = this;
  }
  
  Instance.fromPack(data) {
    map = new GameMap.fromPack(data["map"]);
    unpack(data);
  }
  pack() {
    List tmpheros = heros.values.toList(); // Copy to avoid concurrency issues
    List tmpactors = actors.toList();
    return {
      "open"    : open,
      "heros"   : tmpheros.map((hero) => {"name": hero.name, "hero":hero.pack()}).toList(), // pack each hero
      "actors"  : tmpactors.map((act) => act.pack()).toList(), // pack each actor
      "map"     : map.pack() // pack the map
    };
  }
  unpack(data) {
    open = data["open"];
    
    // expensively overwrites hero list each time, should really update them
    heros = {}; // clear so that disconnected players don't show
    for (var hd in data["heros"]) { // unpack each hero
      heros[hd["name"]] = new Hero.fromPack(hd["hero"]);
    }
    
    actors = []; // Clear the list of actors
    for (var ad in data["actors"]) { // unpack each actor
      if (ad["being"] != null)
        actors.add(new Being.fromPack(ad));
      else
        actors.add(new Actor.fromPack(ad));
    }
    
    map.unpack(data["map"]);
  }
  
}