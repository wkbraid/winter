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
    dead = (vx.truncate() == 0) && (vy.truncate() == 0) && Tile.solid(edges.down);
    super.update(dt); // physics and move
  }
  
  num collideX(num dx) {
    if ((dx < 0 && Tile.solid(edges.left)) || dx > 0 && Tile.solid(edges.right)) {
      vx *= -0.9;
      return 0;
    }
    return dx; // No collision
  }
  num collideY(num dy) {
    if ((dy < 0 && Tile.solid(edges.up)) || dy > 0 && Tile.solid(edges.down)) {
      vy *= -0.9; // bounce
      return 0;
    }
    return dy; // No collision
  }
  
  void collide(Actor other) {
    if (other is Being && other != caster) {
      dead = true;
      other.hp -= damage; // damage the actor
    }
  }
}