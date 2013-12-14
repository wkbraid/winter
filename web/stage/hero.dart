// file: hero.dart
part of stage;

class Hero extends Actor {
  // Our very own hero!
  
  // is there something below our hero?
  bool down = false;
  
  // Call the default actor constructor
  Hero(map,x,y,vx,vy) : super(map,x,y,vx,vy) {
    // set the hero's height
    height = 28;
    width = 20;
  }
  
  void update() {
    
    // work out accelleration of the hero
    if (Keyboard.isDown(KeyCode.LEFT)) vx -= 0.2;
    if (Keyboard.isDown(KeyCode.RIGHT)) vx += 0.2;
    if (Keyboard.isDown(KeyCode.UP) && down)  vy -= 20; //only jump if on a surface
    if (Keyboard.isDown(KeyCode.DOWN)) vy += 0.2;
    vx *= 0.95; //horizontal fricton
    vy += 0.7; // gravity
    vy *= 0.95; //vertical friction
    
    move(vx,vy);
  }
  
  void move(num dx, num dy) {
    num ts = 32; // should not be here permenantly
    
    // reset ground status
    down = false;
    
    // VERTICAL MOVEMENT
    if (dy > 0) {
      // check downwards
      var downwards = map.get(x-width/2,y+dy+height/2)
                    + map.get(x+width/2,y+dy+height/2);
      if (downwards != 0) {
        vy = 0; // stop the vertical speed
        dy = 0; // don't move any farther
        down = true;
      }
    }else if (dy < 0) {
      // check upwards
      var upwards =   map.get(x-width/2,y+dy-height/2)
                    + map.get(x+width/2,y+dy-height/2);
      if (upwards != 0) {
        vy = 0; // stop the vertical speed
        dy = 0; // don't move any farther
      }
    }
    
    // HORIZONTAL MOVEMENT
    if (dx > 0) {
      // check right
      var right = map.get(x+dx+width/2,y-height/2)
                    + map.get(x+dx+width/2,y+height/2);
      if (right != 0) {
        vx = 0; // stop the vertical speed
        dx = 0; // don't move any farther
      }
    }else if (dx < 0) {
      // check upwards
      var left =   map.get(x+dx-width/2,y-height/2)
                    + map.get(x+dx-width/2,y+height/2);
      if (left != 0) {
        vx = 0; // stop the vertical speed
        dx = 0; // don't move any farther
      }
    }
    y += dy;
    x += dx;
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