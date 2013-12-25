// file: common.dart
library common;

class Sync {
  // Base class for all objects which will be synced across the server
  Sync(); // Basic constructor for inheritance
  Sync.fromPack(dynamic data) { } // Create the object from recieved changes
  dynamic pack() { } // pack changes to be sent
  void unpack(dynamic data) { } // unpack changes recieved
}

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
  
  Character(this.mapid,this.x,this.y);
  
  // packing
  Character.fromPack(dynamic data) {
    mapid = data["mapid"];
    x = data["x"]; y = data["y"];
  }
  dynamic pack() => {
    "mapid" : mapid,
    "x" : x,
    "y" : y
  };
  void unpack(dynamic data) {
    mapid = data["mapid"];
    x = data["x"]; y = data["y"];
  }
}