// file: hero.dart
part of stage;

class Hero extends Actor {
  // Our very own genderless hero!
  
  // Call the default actor constructor
  Hero(x,y,map,actors) : super(x,y,map,actors) {
    // set the hero's height
    height = 60;
    width = 60;
  }
  
  void update() {
    
    // work out acceleration of the hero
    if (Keyboard.isDown(KeyCode.A)) vx -= 0.2;
    if (Keyboard.isDown(KeyCode.D)) vx += 0.2;
    if (Keyboard.isDown(KeyCode.W) && down)  vy -= 20; //only jump if on a surface
    if (Keyboard.isDown(KeyCode.S)) vy += 0.2;
    
    // growing commands
    if (Keyboard.isDown(KeyCode.E)) { height += 1; width += 1; y -= 1/2;}
    if (Keyboard.isDown(KeyCode.Q)) { if (height > 1){height -= 1; width -= 1; }}
    
    // projectile commands
    if (Mouse.down) {
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