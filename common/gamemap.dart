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
    
    // TODO: Remove dead actors
    tmp = actors.toList();
    for (Actor act in tmp) { // update all other actors
      act.update(dt);
    }
  }
  
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