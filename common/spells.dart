part of common;

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
  
  void update() { // update the effects of the buff
    duration--;
  }
}