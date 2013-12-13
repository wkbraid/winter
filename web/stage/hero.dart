// file: hero.dart
part of stage;

class Hero extends Actor {
  // Our very own hero!
  
  // Call the default actor constructor
  Hero(map,x,y,vx,vy) : super(map,x,y,vx,vy) {
    // set the hero's height
    height = 28;
    width = 20;
  }
  
  void update() {
    if (Keyboard.isDown(KeyCode.LEFT)) vx -= 0.2;
    if (Keyboard.isDown(KeyCode.RIGHT)) vx += 0.2;
    if (Keyboard.isDown(KeyCode.UP) && y > 190)  vy -= 30; //only jump if on a surface
    if (Keyboard.isDown(KeyCode.DOWN)) vy += 0.2;
    vx *= 0.95; //horizontal fricton
    vy = 0.95*vy + 3; //vertical friction + gravity 
    if (y + vy > 200) {
      vy = 0;
      y = 200; //temporary floor 
    }
    if (map.collisions(x, y, vx, vy).type == 1) {
      if ((vx > 0) && (x == map.collisions(x, y, vx, vy).x)) {
        //collision from right
      }
      x += (map.collisions(x, y, vx, vy).x - x - map.collisions(x, y, vx, vy).ts - (width / 2));
      vy = 0;
      vx = 0;
    }
    x += vx; //updated x
    y += vy; //updated y
  }
  
  void draw() {
    // get the viewcontext from the map we are on
    var context = map.view.viewcontext;
    context.fillStyle = "red";
    context.lineWidth = 2;
    context.strokeStyle = "darkred";
    context.fillRect(x-width/2, y-width/2, width, height);
    context.strokeRect(x-width/2, y-width/2, width, height);
  }
}