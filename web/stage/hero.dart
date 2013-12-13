// file: hero.dart
part of stage;

class Hero extends Actor {
  // Our very own hero!
  
  // Call the default actor constructor
  Hero(map,x,y) : super(map,x,y) {
    // set the hero's height
    height = 28;
    width = 20;
  }
  
  void update() {
    if (Keyboard.isDown(KeyCode.LEFT)) x -= 2;
    if (Keyboard.isDown(KeyCode.RIGHT)) x += 2;
    if (Keyboard.isDown(KeyCode.UP)) y -= 2;
    if (Keyboard.isDown(KeyCode.DOWN)) y += 2;
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