// file: gamemap.dart
part of common;

class GameMap extends Sync {
  // Represents a game map instance
  // Handles the map scenery, as well as all the actors on the map
  
  num ts = 32; // Tile size in map coordinates
  List<List<int>> tdata; // Row major representation of the tile data
  
  Map<String,Hero> heros = {}; // Players on the map, accessed by username
  List<Actor> actors = []; // All other actors on the map
  
  GameMap(this.actors,this.tdata) {
    for (Actor act in actors) { // Set the map for each actor
      act.map = this;
    }
  }
  
  void update(num dt) {
    var tmp = heros.values.toList(); // copy to stop concurrency issues
    for (Hero hero in tmp) {
      hero.update(dt); // update each player on the map
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
  void addHero(Hero hero) { // Add a player to the map
    if (heros.containsKey(hero.name))
      print("Warning! Hero already on map");
    heros[hero.name] = hero; // add the player to the map
  }
  void removeHero(Hero hero) { // Remove a character from the map by name
    heros.remove(hero.name);
  }
  
  // === Actors ===
  void addActor(Actor act) { // Add an actor to the map
    actors.add(act);
    act.map = this; // Set the actor's map
  }
  
  // get the tile at position x,y
  num get(x,y) {
    if (x >= 0 && x < tdata[0].length*ts && y >= 0 && y < tdata.length*ts)
      return tdata[y ~/ ts][x ~/ ts];
    else
      return 1; // everything outside the map is unwalkable by default
  }
  
  
  // ==== PACKING ====
  GameMap.fromPack(data) {
    for (var hd in data["heros"]) // unpack each player
      heros[hd["user"]] = new Hero.fromPack(hd["hero"]);
        
    tdata = data["tdata"]; // load the map tiles
  }
  pack() {
    List tmpheros = heros.values.toList(); // Copy to avoid concurrency issues
    List tmpactors = actors.toList();
    return {
      "heros"   : tmpheros.map((hero) => {"name": hero.name, "hero":hero.pack()}).toList(), // pack each hero
      "actors"  : tmpactors.map((act) => act.pack()).toList(), // pack each actor
      "tdata"   : tdata
    };
  }
  unpack(data) {
    // expensively overwrites hero list each time, should really update them
    heros = {}; // clear so that disconnected players don't show
    for (var hd in data["heros"]) { // unpack each hero
      heros[hd["name"]] = new Hero.fromPack(hd["hero"]);
    }
    
    actors = []; // Clear the list of actors
    for (var ad in data["actors"]) { // unpack each actor
      actors.add(new Actor.fromPack(ad));
    }
    
    tdata = data["tdata"]; // load the map tiles
  }
}