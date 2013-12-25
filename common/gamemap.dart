// file: gamemap.dart
part of common;

class GameMap extends Sync {
  List<Player> players = [];
  
  GameMap();
  
  void addPlayer(Player p) { // Add a player to the map
    players.add(p);
  }
  
  // packing
  GameMap.fromPack(data) {
    players = data["players"].map((pd) => new Player.fromPack(pd)).toList();
  }
  pack() {
    return {
      // pack up the players
      "players":players.map((p) => p.pack()).toList()
    };
  }
  unpack(data) {
    // expensively overwrites player list each time, should really update them
    players = data["players"].map((pd) => new Player.fromPack(pd)).toList();
  }
}