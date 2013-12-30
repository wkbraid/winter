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
    dead = (vx.truncate() == 0) && (vy.truncate() == 0) && edges.down.contains(Tile.WALL);
    super.update(dt); // physics and move
  }
  
  num collideX(num dx) {
    if ((dx < 0 && edges.left.contains(Tile.WALL)) || dx > 0 && edges.right.contains(Tile.WALL)) {
      vx *= -0.9;
      return 0;
    }
    return dx; // No collision
  }
  num collideY(num dy) {
    if ((dy < 0 && edges.up.contains(Tile.WALL)) || dy > 0 && edges.down.contains(Tile.WALL)) {
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