// file: stats.dart
// contains: Stats, Inventory

part of common;

class Stats {
  // Class for holding static statistics, used by hero/items/buffs
  num hp,hpmax,mp,mpmax,jump,speed; // all of the stats
  Stats({this.hpmax:0,this.mpmax:0,this.jump:0,this.speed:0}); // everything is zero by default
  Stats operator+(Stats other) { // add the stats together and return a new Stats object
    if (other != null) {  
      Stats result = new Stats();
      result.hpmax = hpmax + other.hpmax; // it would be nice to find a more compact way of doing this
      result.mpmax = mpmax + other.mpmax;
      result.jump = jump + other.jump;
      result.speed = speed + other.speed;
      return result;
    }
  }
  
  // stats are equal if all of their internal components are equal
  int get hashCode => hpmax.hashCode+5*mpmax.hashCode+7*jump.hashCode+11*speed.hashCode;
  bool operator==(other) =>
      hpmax == other.hpmax && mpmax == other.mpmax
      && jump == other.jump && speed == other.speed;
  
  // packing
  Stats.fromPack(data) {
    hpmax = data["hpmax"]; mpmax = data["mpmax"];
    jump = data["jump"]; speed = data["speed"];
  }
  pack() {
    return {
      "hpmax" : hpmax, "mpmax" : mpmax,
      "speed" : speed, "jump" : jump
    };
  }
  unpack(data) {
    hpmax = data["hpmax"]; mpmax = data["mpmax"];
    jump = data["jump"]; speed = data["speed"];
  }
}

class Inventory {
  // the hero's inventory
  // HOW IT WORKS:
  // The inventory is divided into two parts: equipment and backpack
  // Equipment holds one item for each item slot defined by Equipable.TYPE
  // Backpack will hold all unequipped items
  // The backpack will endlessly stack any items defined to be identical by their hashCode function
  
  List<Equipable> equipment = new List(6); // equipped items
  Map<Item,int> backpack = {}; // unequipped items
  
  Stats get stats => // get the stat bonus from the inventory
    equipment.fold(new Stats(), (acc,item) {
        if (item != null)
          return acc + item.stats;
        else
          return acc;
    });
  
  bool equip(Equipable item) {
    if (equipment[item.type] == null || unequip(equipment[item.type])) { // is the equipment slot free?
      if (take(item)) { // take the item from the backpack
        equipment[item.type] = item; // equip the item
        return true;
      }
    }
    return false; // might also fail later if some items are non-equipable
  }
  
  bool unequip(Equipable item) {
    if (put(item)) {
      equipment[item.type] = null; // unequip the item
      return true;
    }
    return false;
  }
  
  bool take(Item item, {num count : 1}) { // take an item from the backpack
    if (backpack[item] > count)
      backpack[item] -= count;
    else if (backpack[item] == count)
      backpack.remove(item);
    else
      return false; // not enough items to take
    return true; // otherwise we succeeded
  }
  bool put(Item item, {num count : 1}) { // put an item into the backpack
    if (backpack.containsKey(item))
      backpack[item] += count;
    else
      backpack[item] = count;
    return true; // for now always succeeds, might later fail if backpack is full
  }
  
  // ==== PACKING ====
  pack() {
    var data = {};
    data["equipment"] = [];
    var tmp = equipment.toList();
    for (Equipable item in tmp) {
      if (item != null)
        data["equipment"].add(item.pack());
    }
    
    tmp = backpack.keys.toList(); // take a copy for concurrency
    data["backpack"] = [];
    for (Item item in tmp) { // pack up the backpack
      data["backpack"].add({"key":item.pack(),"value":backpack[item],"equipable": item is Equipable});
    }
    return data;
  }
  unpack(data) {
    equipment = new List(6);
    for (var itemd in data["equipment"]) {
      Equipable item = new Equipable.fromPack(itemd);
      equipment[item.type] = item;
    }
    backpack = {}; // expensively overwrite backpack
    for (var kvpair in data["backpack"]) {
      if (kvpair["equipable"]) // TODO find a better way to do this
        backpack[new Equipable.fromPack(kvpair["key"])] = kvpair["value"];
      else
        backpack[new Item.fromPack(kvpair["key"])] = kvpair["value"];
    }
  }
}