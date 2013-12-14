// file: hero.dart
part of stage;

class Hero extends Actor {
  // Our very own hero!
  
  // Call the default actor constructor
  Hero(map,x,y,vx,vy) : super(map,x,y,vx,vy) {
    // set the hero's height
    height = 120;
    width = 120;
  }
  
  void update() {
    
    // work out accelleration of the hero
    if (Keyboard.isDown(KeyCode.LEFT)) vx -= 0.2;
    if (Keyboard.isDown(KeyCode.RIGHT)) vx += 0.2;
    if (Keyboard.isDown(KeyCode.UP) && down)  vy -= 20; //only jump if on a surface
    if (Keyboard.isDown(KeyCode.DOWN)) vy += 0.2;
    
    // growing commands
    if (Keyboard.isDown(KeyCode.A)) { height += 1; width += 1; y -= 1/2;}
    if (Keyboard.isDown(KeyCode.S)) { height -= 1; width -= 1; }
    
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