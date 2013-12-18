// file: hero.dart
part of stage;

class Hero extends Being {
  // Our very own genderless hero!
  
  // Add mana to basic stats
  num mp;
  num mpmax = 100;
  
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
    
    // projectile commands
    if (Mouse.down && mp > pelletSpell.mana) {
      mp -= pelletSpell.cast(this);
    }
    
    // summon enemies!
    if (Keyboard.isDown(KeyCode.SPACE)) {
      stage.actors.add(new RandEnemy(x,y,stage));
    }
    // summon enemies!
    if (Keyboard.isDown(KeyCode.Z)) {
      stage.actors.add(new FlyingEnemy(x,y,stage));
    }
    
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