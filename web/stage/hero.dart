// file: hero.dart
part of stage;

class Hero extends Being {
  // Our very own genderless hero!

  // Spell keybindings for the hero
  Spell mousespell;
  Map<int,Spell> spellkeys;
  
  List<Item> inv = []; // The inventory of the hero
  
  num speed = 0.2; // The speed of the hero
  num jump = 20; //The jump height of the hero
  
  // Call the default actor constructor
  Hero(x,y,stage) : super(x,y,stage) {
    // Set up the hero's spells
    spellkeys = {
       KeyCode.Z : new PelletSpell(this),
       KeyCode.X : new SpawnSpell(this),
       KeyCode.C : new HealSpell(this),
       KeyCode.V : new PortalSpell(this),
       KeyCode.T : new MapSpell(this),
    };
    mousespell = new PelletSpell(this);
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
    for (int key in spellkeys.keys) {
      if (Keyboard.isDown(key))
        mp -= spellkeys[key].cast(this);
    }
    
    // drop the top item in the inventory
    if (Keyboard.isDown(KeyCode.Q) && inv.isNotEmpty) drop(inv.first);
    
    // use the top item in the inventory
    if (Keyboard.isDown(KeyCode.U) && inv.isNotEmpty) inv.first.use(this);
    
    // Check for mouse
    if (Mouse.down)
      mp -= mousespell.cast(this);
    
    super.update();
  }
  
  void drop(Item item) {
    inv.remove(item);
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
    if (other is Enemy)
      hp -= 1;
    else if (other is Pickupable && Keyboard.isDown(KeyCode.S)) {
      // pick up the item
      other.dead = true;
      inv.add(other.item);
    }
  }
}