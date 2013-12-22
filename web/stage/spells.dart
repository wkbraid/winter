// file: spells.dart
part of stage;

class Spell {
  // The base class for all spells castable by actors
  num cooldown = 500; // cooldown in miliseconds
  DateTime lastcast; // last time when the spell was cast 
  num mana = 5; // mana cost
  Being caster; // the caster of the spell
  
  Spell(this.caster) {
    lastcast = new DateTime.utc(2013); // a long time ago
  }
  
  // placeholder functions
  void effects() { }
  bool possible() => true; // no restrictions by default
  
  bool cast() { // cast the spell
    if (-lastcast.difference(new DateTime.now()).inMilliseconds > cooldown
        && caster.mp > mana && possible()) {
      lastcast = new DateTime.now();
      effects(); // cast the spell effects
      caster.mp -= mana;
      return true; // the cast succedded 
    }
    return false; // nothing happened
  }
}

class Buff {
  // Base buff class, long term spell effect on a single being
  
  Being target; // the Being the buff has been cast on
  int duration; // How much longer will the effect be in play
  String color; // what color should the buff icon be drawn
  
  Buff(this.target);
  
  void update() { // update the effects of the buff
    duration--;
  }
}

class PoisonBuff extends Buff {
  // Simple poison buff, reduces hp steadily while active
  PoisonBuff(target) : super(target) {
    duration = 60; // 60 frames duration
    color = "green";
  }
  void update() {
    super.update();
    target.hp -= 1;
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
    caster.stage.addActor(new Projectile(caster.x,caster.y,
        caster.vx + (Mouse.x - posx)*20/dist,
        caster.vy + (Mouse.y - posy)*20/dist,
        10, caster,
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
    caster.hp += 0.5;
  }
  
  bool possible() => caster.hp < caster.hpmax; // only heal if we have less than full hp
}

class SpawnSpell extends Spell {
  // spawns an enemy at the caster's location
  SpawnSpell(caster) : super(caster) {
    mana = 30; cooldown = 1000;
  }
  void effects() {
    caster.stage.addActor(new RandEnemy(caster.x,caster.y,caster.stage));
  }
}

class PortalSpell extends Spell {
  // creates a portal in front of the caster, leading back to the caster's position
  PortalSpell(caster) : super(caster) {
    mana = 70; cooldown = 5000;
  }
  void effects() {
    caster.stage.addActor(new Portal(Mouse.x + caster.stage.view.x,
                                     Mouse.y + caster.stage.view.y,
                                     50,50,"test",caster.stage));
  }
}

class MapSpell extends Spell {
  // for testing purposes only, changes the map on which the hero is currently on
  MapSpell(caster) : super(caster) {
    mana = 90; cooldown = 4000;
  }
  void effects() {
      caster.mapid = "miles1";
      caster.stage.loadMap(caster.mapid);
      caster.x = 550;
      caster.y = 200;
  }
}

class SelfPoisonSpell extends Spell {
  SelfPoisonSpell(caster) : super(caster);
  
  void effects() {
    // poison the caster
    caster.buffs.add(new PoisonBuff(caster));
  }
}