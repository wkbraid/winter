// file: hero.dart
part of stage;

class Hero extends Actor {
  // Our very own hero!
  
  // basic stats
  num hp;
  num mp;
  // stat maximums, should be set elsewhere probably
  num hpmax = 100;
  num mpmax = 100;
  
  // Call the default actor constructor
  Hero(x,y,map,actors) : super(x,y,map,actors) {
    // set the hero's height
    height = 30;
    width = 30;
    hp = hpmax/2;
    mp = mpmax;
  }
  
  void update() {
    // deal with health and mana
    if (hp < hpmax) hp+= 0.1;
    if (mp < mpmax) mp+= 0.15;
    
    // work out accelleration of the hero
    if (Keyboard.isDown(KeyCode.A)) vx -= 0.2;
    if (Keyboard.isDown(KeyCode.D)) vx += 0.2;
    if (Keyboard.isDown(KeyCode.W) && down)  vy -= 20; //only jump if on a surface
    if (Keyboard.isDown(KeyCode.S)) vy += 0.2;
    
    // growing commands
    if (Keyboard.isDown(KeyCode.Q)) { height += 1; width += 1; y -= 1/2;}
    if (Keyboard.isDown(KeyCode.E)) { height -= 1; width -= 1; }
    
    // projectile commands
    if (Mouse.down && mp > 5) {
      mp -= 5;
      num posx = map.view.width/2;
      num posy = map.view.height/2;
      num dist = sqrt(pow(posx-Mouse.x,2)+pow(posy - Mouse.y, 2));
      actors.add(new Projectile(x,y,
          vx + (Mouse.x - posx)*20/dist,
          vy + (Mouse.y - posy)*20/dist,
        map,actors));
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
  
  void draw() {
    // get the viewcontext from the map we are on
    var context = map.view.viewcontext;
    context.fillStyle = "red";
    context.lineWidth = 2;
    context.strokeStyle = "darkred";
    context.fillRect(x-width/2, y-height/2, width, height);
    context.strokeRect(x-width/2, y-height/2, width, height);
  }
}