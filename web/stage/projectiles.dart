// projectiles.dart
part of stage;

class Projectile extends Actor {
  
  Projectile(x,y,vx,vy,map,actors) : super(x,y,map,actors) {
    this.vx = vx;
    this.vy = vy;
    width = 5;
    height = 5;
  }
  
  void update() {
    vx *= 0.95; //horizontal fricton
    vy += 0.7; // gravity
    vy *= 0.95; //vertical friction
    move(vx,vy);
  }
  
  num collideX(num dx) {
    vx *= -0.9;
    return 0;
  }
  num collideY(num dy) {
    vy *= -0.9;
    if (dy > 0) down = true;
    return 0;
  }
 
  void draw() {
    // get the viewcontext from the map we are on
    var context = map.view.viewcontext;
    context.fillStyle = "purple";
    context.lineWidth = 1;
    context.strokeStyle = "darkpurple";
    context.fillRect(x-width/2, y-height/2, width, height);
    context.strokeRect(x-width/2, y-height/2, width, height);
  }
  
  bool dead() {
    return (vx.truncate() == 0) && (vy.truncate() == 0) && down;
  }
}