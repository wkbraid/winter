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
  // Stores information about the hero persistent upon logoff
  String mapid; // The mapid of the map the character is on
  num x,y; // Character position in map coordinates
  Stats stats; // The character's stats
  
  Character(this.mapid,this.x,this.y,this.stats);
  
  // packing
  Character.fromPack(dynamic data) {
    mapid = data["mapid"];
    x = data["x"]; y = data["y"];
    stats = new Stats.fromPack(data["stats"]);
  }
  dynamic pack() => {
    "mapid" : mapid,
    "x" : x,
    "y" : y,
    "stats" : stats.pack()
  };
  void unpack(dynamic data) {
    mapid = data["mapid"];
    x = data["x"]; y = data["y"];
    stats.unpack(data["stats"]);
  }
}