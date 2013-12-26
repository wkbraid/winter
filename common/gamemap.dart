// file: gamemap.dart
part of common;

class GameMap extends Sync {
  // Represents a game map instance
  // Handles the map scenery, as well as all the actors on the map
  
  num ts = 32; // Tile size in map coordinates
  List<List<int>> tdata; // Row major representation of the tile data
  
  Map<String,Player> players = {}; // Players on the map, accessed by username
  
  GameMap(this.tdata);
  
  void update(num dt) {
    var tmp = players.values.toList(); // copy to stop concurrency issues
    for (Player p in tmp)
      p.update(dt); // update each player on the map
  }
  
  // Handle Players
  void addPlayer(Player p) { // Add a player to the map
    if (players.containsKey(p.name))
      print("Warning! Player already on map");
    players[p.name] = p; // add the player to the map
  }
  void removePlayer(String name) { // Remove a character from the map by name
    players.remove(name);
  }
  void updatePlayer(String name, data) { // update a player by name
    players[name].vx += (data["right"] - data["left"])*20/1000;
    players[name].vy += (data["down"] - data["up"])*20/1000;
  }
  
  // packing
  GameMap.fromPack(data) {
    for (var pd in data["players"]) // unpack each player
      players[pd["user"]] = new Player.fromPack(pd["player"]);
        
    tdata = data["tdata"]; // load the map tiles
  }
  pack() {
    List tmp = [];
    players.forEach((user,p) { // pack each player
      tmp.add({"user":user,"player":p.pack()});
    });
    return {
      "players": tmp,
      "tdata"   : tdata
    };
  }
  unpack(data) {
    // expensively overwrites player list each time, should really update them
    players = {}; // clear so that disconnected players don't show
    for (var pd in data["players"]) // unpack each player
      players[pd["user"]] = new Player.fromPack(pd["player"]);
    
    tdata = data["tdata"]; // load the map tiles
  }
}