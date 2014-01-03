// file: enemy.dart
// contains: Enemy, RandEnemy

part of common;

class Mob extends Actor {
  // A mob of enemies 
  
  List<Enemy> enemies; // the component enemies of the mob
  
  Mob(x,y,this.enemies) : super(x,y) {
    width = 20;
    height = 20;
    color = "yellow";
  }
  
  void update(dt) { // Stolen random enemy movement for now
    // decide whether we should randomly jump
    var rand = new Random();
    if (rand.nextDouble() < 0.01 && edges.down.contains(Tile.WALL))
      vy -= 18;
    // now decide which way we should push
    if (vx.abs() < 1)
      vx += (rand.nextDouble() - 0.5)*dt;
    else
      vx += vx/1400*dt;
    
    super.update(dt); // physics and move the enemy
  }
  
  void fight(Hero hero) { // start a fight with a hero
    if (hero.instance is Battle) {
      print("Tried to start two battles at once");
      return;
    }
    Battle battle = new Battle();
    instance.map.addInstance(battle); // The battle takes place on the map
    
    instance.addActor(new BattlePortal(x,y,battle)); // place portals to enter the battle
    instance.addActor(new BattlePortal(hero.x,hero.y,battle));
    battle.addActor(this);
    battle.addHero(hero); // add the contestants to the battle
  }
  
  void collide(Actor other) {
    if (other is Hero) {
      // All mobs are aggressive for now
      fight(other);
    }
  }
}

class Enemy extends Being {
  // Basic enemy class, abstracts most functionality other than AI decisions
  
  Enemy(x,y,base) : super(x,y,base) {
    color = "orange"; // drawing colors
    target = this; // default target self
  }
  
  void update(dt) {
    if (hp <= 0) dead = true; // check if the enemy is dead
    
    /*
    // targeting
    posx = this.x;
    posy = this.y;
    aimx = stage.hero.x; // default target at hero -- add possibility to target at allies/different heroes later
    aimy = stage.hero.y;
    */
    super.update(dt);
  }

  void collide(Actor other) {
    if (other is Hero) {// attack the hero
      other.hp -= 1;
    }
  }
  //==== PACKING ====
  // Client does not need to know anything special about enemies
  Enemy.fromPack(data) : super.fromPack(data);
}