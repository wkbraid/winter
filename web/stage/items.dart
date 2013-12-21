// file: items.dart
part of stage;

class Item {
  // Basic item class
  String name; // the name of the item
  Item(this.name);
  
  // use the item, currently only heros have inventories
  void use(Hero user) {
      user.inv.remove(this); // remove the item from the hero's inventory
  }
}

class HealthPotion extends Item {
  // A simple health potion
  HealthPotion() : super("Health Potion");
  
  void use(Hero user) {
    if(user.hp < user.hpmax){
      super.use(user);
      if(user.hp <= (user.hpmax - 30))
        user.hp += 30;
      else user.hp = user.hpmax;
    }
  }
}

class ManaPotion extends Item {
  // A simple mana potion
  ManaPotion() : super("Mana Potion");
  
  void use(Hero user) {
    if(user.mp < user.mpmax){
      super.use(user);
      if(user.mp <= user.mpmax - 30)
        user.mp += 30;
      else user.mp = user.mpmax;
    }
  }
}