// file: gamemap.dart
part of common;

class GameMap extends Sync {
  // Represents a game map instance
  // Handles the map scenery, as well as all the actors on the map
  
  num ts = 32; // Tile size in map coordinates
  List<List<int>> tdata; // Row major representation of the tile data
  
  Map<String,Hero> heros = {}; // Players on the map, accessed by username
  
  GameMap(this.tdata);
  
  void update(num dt) {
    var tmp = heros.values.toList(); // copy to stop concurrency issues
    for (Hero hero in tmp)
      hero.update(dt); // update each player on the map
  }
  
  // Handle Players
  void addHero(Hero hero) { // Add a player to the map
    if (heros.containsKey(hero.name))
      print("Warning! Hero already on map");
    heros[hero.name] = hero; // add the player to the map
  }
  void removeHero(Hero hero) { // Remove a character from the map by name
    heros.remove(hero.name);
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
    List tmp = heros.values.toList(); // Copy to avoid concurrency issues
    return {
      "heros": tmp.map((hero) => {"name": hero.name, "hero":hero.pack()}).toList(), // pack each hero
      "tdata"   : tdata
    };
  }
  unpack(data) {
    // expensively overwrites hero list each time, should really update them
    heros = {}; // clear so that disconnected players don't show
    for (var hd in data["heros"]) // unpack each hero
      heros[hd["name"]] = new Hero.fromPack(hd["hero"]);
    
    tdata = data["tdata"]; // load the map tiles
  }
}