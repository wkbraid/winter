// file: account.dart
part of common;


class Account extends Sync {
  // Holds basic account information, returned from the server when a login is authenticated
  String user; // Username
  Character char; // The character associated with this account
  
  Account(this.user,this.char);
  
  // packing
  Account.fromPack(dynamic data) {
    user = data["user"];
    char = new Character.fromPack(data["char"]);
  }
  dynamic pack() => {
    "user" : user,
    "char" : char.pack()
  };
  void unpack(dynamic data) {
    user = data["user"];
    char.unpack(data["char"]);
  }
}

class Character extends Sync {
  // Stores information about the hero not visible to everyone
  
  String name; // The character's name (should be unique)

  String mapid; // The mapid of the map the character is on
  Stats stats; // The character's stats
  
  Character(this.name,this.mapid,this.stats);
  
  // ==== PACKING ====
  Character.fromPack(dynamic data) {
    name = data["name"];
    mapid = data["mapid"];
    stats = new Stats.fromPack(data["stats"]);
  }
  dynamic pack() => {
    // NB: Should be careful what character information you give to the clients
    "mapid" : mapid,
    "stats" : stats.pack(),
    "name" : name
  };
  void unpack(dynamic data) {
    mapid = data["mapid"];
    stats.unpack(data["stats"]);
    name = data["name"];
  }
}