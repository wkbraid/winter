// file: hero.dart
part of stage;

class Inventory {
  // the hero's inventory
  // HOW IT WORKS:
  // The inventory is divided into two parts: equipment and backpack
  // Equipment holds one item for each item slot defined by Equipable.TYPE
  // Backpack will hold all unequiped items
  // The backpack will endlessly stack any items defined to be identical by their hashCode function
  
  List<Equipable> equipment = new List(6); // equiped items
  Map<Item,int> backpack = {}; // unequiped items
  
  bool equip(Equipable item) {
    if (take(item)) { // the item was in the backpack
      if (equipment[item.type] != null) {
        put(equipment[item.type]); // add the item back to the backpack
      }
      equipment[item.type] = item; // equip the item
      return true;
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
    return true; // otherwise we succedded
  }
  bool put(Item item, {num count : 1}) { // put an item into the backpack
    if (backpack.containsKey(item))
      backpack[item] += count;
    else
      backpack[item] = count;
    return true; // for now always succeeds, might later fail if backpack is full
  }
}

class Hero extends Being {
  // Our very own genderless hero!

  // Spell keybindings for the hero
  Map<int,String> Keybindings = {}; // keybindings should eventually be taken care of by the gui
  String mousespell;
  
  Inventory inv; // The inventory of the hero
  
  num speed = 0.2; // The speed of the hero
  num jump = 20; //The jump height of the hero
  
  // Call the default actor constructor
  Hero(x,y,stage) : super(x,y,stage) {
    // Set up the hero's spells
    spells = {
       "pellet" : new PelletSpell(this),
       "spawn"  : new SpawnSpell(this),
       "heal"   : new HealSpell(this),
       "portal" : new PortalSpell(this),
       "map"    : new MapSpell(this),
       "poison" : new SelfPoisonSpell(this)
    };
    Keybindings = {
      KeyCode.Z : "pellet",
      KeyCode.X : "spawn",
      KeyCode.C : "heal",
      KeyCode.V : "portal",
      KeyCode.T : "map",
      KeyCode.P : "poison"
    };
    mousespell = "pellet";
    inv = new Inventory();
    
    width = 30; // set the hero's dimension
    height = 30;
    color = "red"; // drawing colors
    bordercolor = "darkred";
    mp = mpmax;
  }
  
  void update() {
    // deal with health and mana
    if (hp < hpmax) hp+= 0.1;
    if (mp < mpmax) mp+= 0.5;
    
    // work out acceleration of the hero
    if (Keyboard.isDown(KeyCode.A)) vx -= speed;
    if (Keyboard.isDown(KeyCode.D)) vx += speed;
    if (Keyboard.isDown(KeyCode.W) && down)  vy -= jump; //only jump if on a surface

    // Check for keybindings
    for (int key in Keybindings.keys) {
      if (Keyboard.isDown(key))
        spells[Keybindings[key]].cast();
    }
    
    // Check for mouse
    if (Mouse.down)
      spells[mousespell].cast();
    
    super.update();
  }
  
  void drop(Item item, {num count : 1}) {
    inv.take(item, count: count);
    stage.addActor(new Pickupable(x,y,item,stage));
  }
  
  num collideY(num dy) {
    if (dy > 0) {
      down = true;
    }
    if (vy > 11)
      hp -= vy*vy*vy/49;
    vy = 0;
    return 0;
  }
  
  void collide(Actor other) {
    if (other is Pickupable && Keyboard.isDown(KeyCode.S)) {
      other.dead = inv.put(other.item); // pick up the item
    } else if (other is Portal && Keyboard.isDown(KeyCode.S)) {
      other.open(this);
    }
  }
}