// file: projectile.dart
part of common;


class Projectile extends Actor {
  num damage; // how much damage it does
  Actor caster; // who cast the projectile
  
  Projectile(x,y,vx,vy,damage,caster) : super(x,y) {
    this.vx = vx;
    this.vy = vy;
    this.damage = damage;
    this.caster = caster;
    width = 5;
    height = 5;
    color = "purple";
  }
  
  void update(dt) {
    dead = (vx.truncate() == 0) && (vy.truncate() == 0) && down;
    super.update(dt); // physics and move
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
    if (other is Being && other != caster) {
      dead = true;
      other.hp -= damage; // damage the actor
    }
  }
}