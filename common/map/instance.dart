// file: instance.dart
// contains: BattleInstance, Instance

part of common;

class Battle extends Instance {
  // An instance of a map on which a battle is taking place
  
  List<BattlePortal> entrances = []; // A list of all the entrances to the battle
  
  void end() { // The battle has ended!
    var tmp = heros.values.toList();
    for (Hero hero in tmp) {
      map.addHero(hero); // Add the heros back to the main map
    }
  }
  
  void update(dt) {
    if (actors.length == 0)
      end(); // pretend the heros won
    
    super.update(dt);
  }
  
  void edge(Hero hero) {
    edgeCorrect(hero); // no other maps from battles
  }
  
  void addActor(Actor act) {
    if (act.instance != null)
      act.instance.removeActor(act);
    if (act is Mob) { // add a mob to the fight
      for (Enemy enemy in act.enemies) {
        addActor(enemy);
      }
    } else {
      actors.add(act);
      act.instance = this;
    }
  }
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
      edge(hero);
    }
    
    
    // remove the dead actors
    actors.removeWhere((act) => act.dead);
    tmp = actors.toList(); // take a copy for concurrency
    for (Actor act in tmp) { // update all other actors
      act.update(dt);
      edgeCorrect(act);
    }
    
    collide(); // check for collision
  }
  
  void edge(Hero hero) { // check if a hero should be transported off the edge
    if (hero.x > ts*mwidth && map.right != null) {
      hero.x = ts*mwidth - hero.x;
      hero.mapid = map.right;
    } else if (hero.x < 0 && map.left != null) {
      hero.x = ts*mwidth + hero.x;
      hero.mapid = map.left;
    } else if (hero.y > ts*mheight && map.down != null) {
      hero.y = ts*mheight - hero.y;
      hero.mapid = map.down;
    } else if (hero.y < 0 && map.up != null) {
      hero.y = ts*mheight + hero.y;
      hero.mapid = map.up;
    } else {
      edgeCorrect(hero); // no maps, stop the hero from falling off
    }
  }
  
  void edgeCorrect(Actor act) {
    if (act.x > ts*mwidth) {
      act.x = ts*mwidth;
      act.vx = 0;
    } else if (act.x < 0) {
      act.x = 0;
      act.vx = 0;
    }
    if (act.y > ts*mheight) {
      act.y = ts*mheight;
      act.vy = 0;
    } else if (act.x < 0) {
      act.y = 0;
      act.vy = 0;
    }
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
      print("Warning! Hero ${hero.name} already on map");
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
  
  // === Actors ===
  void addActor(Actor act) { // Add an actor to the map
    actors.add(act);
    if (act.instance != null)
      act.instance.removeActor(act); // Remove the actor from its previous instance
    act.instance = this;
  }
  void removeActor(Actor act) {
    actors.remove(act);
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