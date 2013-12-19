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
    super.use(user);
    user.hp += 30;
  }
}