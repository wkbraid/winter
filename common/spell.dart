part of common;
// Contains:
// Spell
// Buffs
// Pellet and Poison Spell/buff

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
  Stats stats = new Stats();
  
  Buff(this.target);
  
  void update(dt) { // update the effects of the buff
    duration -= dt;
  }
  
  // ==== PACKING ====
  Buff.fromPack(data) {
    duration = data["duration"];
    color = data["color"];
    stats = stats.unpack(data["stats"]);
  }
  pack() {
    return {
      "duration" : duration,
      "color": color,
      "stats": stats.pack()
    }; // no way to send effects, so those should have a description
  }
}

//===========================================
// Game Spells
//===========================================
// NB: Summon spells (which create beings) should use map.addBeing() to allow teams in battles
class PelletSpell extends Spell {
  // simple missile spell

  PelletSpell(caster) : super(caster) {
    mana = 10;
    cooldown = 200;
  }
  
  void effects() {
    // creates a simple projectile
    num dist = sqrt(pow(caster.x-caster.aimx,2)+pow(caster.y-caster.aimy,2));
    
    caster.instance.addActor(new Projectile(caster.x,caster.y,
        caster.vx + (caster.aimx - caster.x)*20/dist,
        caster.vy + (caster.aimy - caster.x)*20/dist,
        10, caster));
  }
}

class PoisonSpell extends Spell {
  // poisons the caster's target
  PoisonSpell(caster) : super(caster) {
    mana = 10; cooldown = 500;
  }
  void effects() {
    caster.target.buffs.add(new PoisonBuff(caster.target));
  }
}

//==========================================
// Game Buffs
//==========================================
class PoisonBuff extends Buff {
  PoisonBuff(target) : super(target) {
    duration = 1000; // 1 second duration
    color = "green";
  }
  void update(dt) {
    super.update(dt);
    target.hp -= dt/100;
  }
}