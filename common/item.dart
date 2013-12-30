// file: item.dart
part of common;

class Item {
  // Basic item class
  String id;
  String color; // basic graphics for gui
  String desc;
  
  Item(this.id);
  
  // use the item, currently only heros have inventories
  bool use(Hero user) {
    return user.inv.take(this); // try to take the item from the hero's inventory
  }
  
  int get hashCode => id.hashCode; // by default, items are defined to be the same if their ids are the same
  bool operator==(other) => (other is Item) && hashCode == other.hashCode;
  
  // ==== PACKING ====
  Item.fromPack(data) {
    unpack(data);
  }
  pack() {
    return {
      "id" : id,
      "color" : color,
      "desc" : desc,
    };
  }
  unpack(data) {
    id = data["id"];
    color = data["color"];
    desc = data["desc"];
  }
}

class Equipable extends Item {
  // Base class for all equipable items
  
  // Equipable types
  static const HAND = 0; // weapon
  static const HEAD = 1; // armor headgear
  static const RING = 2; // armor ring
  static const FEET = 3; // armor legs
  static const BELT = 4; // armor middle
  static const CAPE = 5; // armor back
  // (yes there is no chest, belt is kind of subsituting for that, and look they all have the same line length
  
  int type; // What type of item is it (from above)
  Stats stats = new Stats();
  
  Equipable(id,type) : super(id) {
    this.type = type;
  }
  
  // Equipables are the same if they have the same type, stats and name
  int get hashCode => super.hashCode * 37 + 17 * type.hashCode + 37*stats.hashCode;
  bool operator==(other) => other is Equipable && type == other.type && stats == other.stats;
  
  // ==== PACKING ====
  Equipable.fromPack(data) : super.fromPack(data) {
    unpack(data);
  }
  pack() {
    var data = super.pack();
    data["type"] = type;
    data["stats"] = stats.pack();
    return data;
  }
  unpack(data) {
    type = data["type"];
    stats.unpack(data["stats"]);
    super.unpack(data);
  }
}
//=============================================
// Game Equipables
//=============================================
class SkiGoggles extends Equipable {
  SkiGoggles() : super("Ski Goggles",Equipable.HEAD) {
    desc = "Perhaps this used to be a ski resort. Perhaps not.";
    color = "brown";
    stats.speed = 0.2; // increases speed by 0.2
  }
}
class PropellorHat extends Equipable {
  PropellorHat() : super("Propellor Hat",Equipable.HEAD) {
    desc = "You can't REALLY fly with one of these, can you? Well, can you?";
    color = "yellow";
    stats.jump = 5; // increases jump by 5
  }
}
class MagicRing extends Equipable {
  //A powerful wizard's energy ring, increases mana.
  MagicRing() : super("Ring of Magic Doing",Equipable.RING) {
    desc = "'A powerful wizard once owned this ring,' they said. But it looks suspiciously like one from a cereal box";
    color = "grey";
    stats.mpmax = 50; // gives 50 mana
  }
}
class ChainMailCape extends Equipable {
  //Spammy chain mail - weighs you down, more prone to viruses -> less health
  ChainMailCape() : super("Cape of Chain Mail - The Worse Kind",Equipable.CAPE) {
    desc = "Chain mail! Look at all these links... to virus-filled web pages! It's THAT kind of chain mail.";
    color = "orange";
    stats.jump = -3; //decreases jump by 3
    stats.hpmax = -25; //decreases health to 3/4 health
  }
}
class ChainMailCape2 extends Equipable {
  //Medieval chain mail - heavy, so slower movement, but better resistance to damage
  ChainMailCape2() : super("Cape of Chain Mail - The Better Kind",Equipable.CAPE) {
    desc = "Chain mail! Look at all these links... the more steel between me and my enemy, the better.";
    color = "orange";
    stats.speed = -3/1000; //decreases speed by 0.2
    stats.hpmax = 100; //doubles max health
  }
}
class UrgencyBoots extends Equipable {
  //Special boots for running away - faster but you take more damage if hit
  UrgencyBoots() : super("Boots of RUNNING AWAY!!!", Equipable.FEET) {
    desc = "Brave Sir Robin ran away. But not as fast as you with these boots.";
    color = "brown";
    stats.speed = 3/1000; //doubles speed
    stats.hpmax = -40; //decreases wearer's max health to 3/5 of base hpmax.
  }
}


//=============================================
// Game Items
//=============================================

class HealthPotion extends Item {
  // A simple health potion
  HealthPotion() : super("Health Potion") {
    desc = "Drink up! Guaranteed* to increase your health.";
    color = "red";
  }
  
  bool use(Hero user) {
    if(super.use(user) && user.hp < user.stats.hpmax){
      if(user.hp <= (user.stats.hpmax - 30))
        user.hp += 30;
      else user.hp = user.stats.hpmax;
      return true;
    }
    return false; // item was not used
  }
}

class ManaPotion extends Item {
  // A simple mana potion
  ManaPotion() : super("Mana Potion") {
    desc = "Drink up! Guaranteed* to increase your mana.";
    color = "blue";
  }
  
  bool use(Hero user) {
    if(super.use(user) && user.mp < user.stats.mpmax){
      if(user.mp <= user.stats.mpmax - 30)
        user.mp += 30;
      else user.mp = user.stats.mpmax;
      return true;
    }
    return false;
  }
}