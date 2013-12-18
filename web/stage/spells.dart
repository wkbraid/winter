// file: spells.dart
part of stage;

class Spell {
  // The base class for all spells castable by actors
  num cooldown = 500; // cooldown in miliseconds
  DateTime lastcast; // last time when the spell was cast 
  num mana = 5; // mana cost
  Being caster; // the caster of the spell
  
  Spell(this.caster) {
    lastcast = new DateTime.now();
  }
  
  // placeholder functions
  void effects() { }
  bool possible() => true; // no restrictions by default
  
  num cast(Being caster) { // cast the spell
    if (-lastcast.difference(new DateTime.now()).inMilliseconds > cooldown
        && caster.mp > mana && possible()) {
      lastcast = new DateTime.now();
      effects(); // cast the spell effects
      return mana;
    }
    return 0; // otherwise the spell didn't cast
  }
}

//===========================================
// Game Spells
//===========================================
class PelletSpell extends Spell {
  // simple missile spell
  PelletSpell(caster) : super(caster) {
    mana = 10;
    cooldown = 200;
  }
  
  void effects() {
    // creates a simple projectile
    num posx = caster.stage.view.width/2;
    num posy = caster.stage.view.height/2;
    num dist = sqrt(pow(posx-Mouse.x,2)+pow(posy - Mouse.y, 2));
    caster.stage.actors.add(new Projectile(caster.x,caster.y,
        caster.vx + (Mouse.x - posx)*20/dist,
        caster.vy + (Mouse.y - posy)*20/dist,
        caster.stage));
  }
}

class HealSpell extends Spell {
  // exchange mana for hp
  HealSpell(caster) : super(caster) {
    mana = 1;
    cooldown = 10;
  }
  
  void effects() {
    caster.hp += 1;
  }
  
  bool possible() => caster.hp < caster.hpmax; // only heal if we have less than full hp
}

class SpawnSpell extends Spell {
  // spawns an enemy at the caster's location
  SpawnSpell(caster) : super(caster) {
    mana = 30; cooldown = 1000;
  }
  void effects() {
    caster.stage.actors.add(new RandEnemy(caster.x,caster.y,caster.stage));
  }
}