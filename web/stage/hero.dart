// file: hero.dart
part of stage;

class Hero extends Being {
  // Our very own genderless hero!
  
  // Spell keybindings for the hero
  Map<int,Spell> spellkeys = {
      KeyCode.Z : pelletSpell,
      KeyCode.X : spawnSpell,
      KeyCode.C : healSpell
    };
  
  Spell mousespell = pelletSpell;
  
  
  // Call the default actor constructor
  Hero(x,y,stage) : super(x,y,stage) {
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
    if (Keyboard.isDown(KeyCode.A)) vx -= 0.2;
    if (Keyboard.isDown(KeyCode.D)) vx += 0.2;
    if (Keyboard.isDown(KeyCode.W) && down)  vy -= 20; //only jump if on a surface
    if (Keyboard.isDown(KeyCode.S)) vy += 0.2;
    
    // growing commands
    if (Keyboard.isDown(KeyCode.E)) { height += 1; width += 1; y -= 1/2;}
    if (Keyboard.isDown(KeyCode.Q)) { if (height > 1){height -= 1; width -= 1; }}
    
    // Check for keybindings
    for (int key in spellkeys.keys) {
      if (Keyboard.isDown(key))
        mp -= spellkeys[key].cast(this);
    }
    // Check for mouse
    if (Mouse.down)
      mp -= mousespell.cast(this);
    
    vx *= 0.95; //horizontal fricton
    vy += 0.7; // gravity
    vy *= 0.95; //vertical friction
    
    move(vx,vy);
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
    if (other.type == "enemy")
      hp -= 1;
  }
}