// projectiles.dart
part of stage;

class Projectile extends Actor {
  num damage;
  
  Projectile(x,y,vx,vy,damage,stage) : super(x,y,stage) {
    this.vx = vx;
    this.vy = vy;
    this.damage = damage;
    width = 5;
    height = 5;
    color = "purple";
    bordercolor = "purple";
  }
  
  void update() {
    dead = (vx.truncate() == 0) && (vy.truncate() == 0) && down;
    super.update(); // physics and move
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
  
  void collide(Actor other) {
    if (other is Enemy)
      dead = true;
  }
}