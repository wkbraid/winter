// file: hero.dart
part of stage;

class Stats {
  // Class for holding statistics, used by hero/items/buffs
  num hp,hpmax,mp,mpmax,jump,speed; // all of the stats
  Stats({this.hp:0,this.hpmax:0,this.mp:0,this.mpmax:0,this.jump:0,this.speed:0}); // everything is zero by default
  Stats operator+(Stats other) { // add the stats together and return a new Stats object
    Stats result = new Stats();
    result.hp = hp + other.hp; // it would be nice to find a more compact way of doing this
    result.hpmax = hpmax + other.hpmax;
    result.mp = mp + other.mp;
    result.mpmax = mpmax + other.mpmax;
    result.jump = jump + other.jump;
    result.speed = speed + other.speed;
    return result;
  }
  
  // stats are equal if all of their internal components are equal
  int get hashCode => hp.hashCode+2*hpmax.hashCode+3*mp.hashCode+5*mpmax.hashCode+7*jump.hashCode+11*speed.hashCode;
  bool operator==(other) =>
      hp == other.hp && hpmax == other.hpmax
      && mp == other.mp && mpmax == other.mpmax
      && jump == other.jump && speed == other.speed;
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
}

class Hero extends Being {
  // Our very own genderless hero!

  // Spell keybindings for the hero
  Map<int,String> Keybindings = {}; // keybindings should eventually be taken care of by the gui
  String mousespell;
  bool settingSpell;
  
  Stats base = new Stats(); // base statistics for the hero
  
  Inventory inv; // The inventory of the hero
  
  // Call the default actor constructor
  Hero(x,y,stage) : super(x,y,stage) {
    // Set up the hero's spells
    spells = {
       "pellet" : new PelletSpell(this),
       "spawn"  : new SpawnSpell(this),
       "heal"   : new HealSpell(this),
       "portal" : new PortalSpell(this),
       "map"    : new MapSpell(this),
       "poison" : new SelfPoisonSpell(this),
       "speed"  : new SpeedSpell(this)
    };
    Keybindings = {
      KeyCode.Z : "pellet",
      KeyCode.X : "spawn",
      KeyCode.C : "heal",
      KeyCode.V : "portal",
      KeyCode.T : "map",
      KeyCode.P : "poison",
      KeyCode.O : "speed"
    };
    mousespell = "pellet";
    inv = new Inventory();
    
    // statistics
    hp = 100;
    hpmax = 100;
    mp = 50;
    mpmax = 100;
    base.jump = 20;
    base.speed = 0.2;
    
    width = 30; // set the hero's dimension
    height = 30;
    color = "red"; // drawing colors
    bordercolor = "darkred";
    
    target = this; // default target self
    
    //~~~~~
    settingSpell = false;
  }
  
  Stats get stats => base + inv.stats + buffs.fold(new Stats(), (acc,buff) => acc + buff.stats); // get the hero's stats
  
  void update() {
    // deal with health and mana
    if (hp < hpmax) hp+= 0.1;
    if (mp < mpmax) mp+= 0.5;
    
    // work out acceleration of the hero
    if (Keyboard.isDown(KeyCode.A)) vx -= stats.speed;
    if (Keyboard.isDown(KeyCode.D)) vx += stats.speed;
    if (Keyboard.isDown(KeyCode.W) && down)  vy -= stats.jump; //only jump if on a surface

    // Check for keybindings
    if(settingSpell){ //check if in spell-setting mode
      for (int key in Keybindings.keys){ //if yes, set spell to left click
        if (Keyboard.isDown(key)){
          mousespell = Keybindings[key];
          settingSpell = false;
        }
     }
    }
    else{
      for (int key in Keybindings.keys){ // if no, cast it
        if (Keyboard.isDown(key))
          spells[Keybindings[key]].cast();
     }
    }
    
    // Check for mouse
    if (Mouse.down)
      spells[mousespell].cast();
    
    // targeting
    posx = stage.view.width/2;
    posy = stage.view.height/2;
    aimx = Mouse.x; // default aim towards the mouse
    aimy = Mouse.y;
    
    //~~~~~HOTBAR Testing
    
    if(Keyboard.isDown(KeyCode.M))//for memoize..
        settingSpell = true;
    
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
      if (other.item is Equipable)
        inv.equip(other.item); // equip it right away
    } else if (other is Portal && Keyboard.isDown(KeyCode.S)) {
      other.open(this);
    }
  }
  

}