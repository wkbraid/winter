// file: spells.dart
part of stage;

class Spell {
  // The base class for all spells castable by actors
  num cooldown = 500; // cooldown in miliseconds
  DateTime lastcast; // last time when the spell was cast 
  num mana = 5; // mana cost
  var effects, possible;
  
  Spell(this.effects, {this.mana, this.cooldown, this.possible}) {
    if (possible == null)
      possible = (Being caster) => true; // there are no additional requirements
    lastcast = new DateTime.now();
  }
  
  num cast(Being caster) { // cast the spell
    if (-lastcast.difference(new DateTime.now()).inMilliseconds > cooldown
        && caster.mp > mana && possible(caster)) {
      lastcast = new DateTime.now();
      effects(caster); // cast the spell effects
      return mana;
    }
    return 0; // otherwise the spell didn't cast
  }
}

//===========================================
// Game Spells
//===========================================
Spell pelletSpell = new Spell((Being caster) {
  // creates a simple projectile
  num posx = caster.stage.view.width/2;
  num posy = caster.stage.view.height/2;
  num dist = sqrt(pow(posx-Mouse.x,2)+pow(posy - Mouse.y, 2));
  caster.stage.actors.add(new Projectile(caster.x,caster.y,
      caster.vx + (Mouse.x - posx)*20/dist,
      caster.vy + (Mouse.y - posy)*20/dist,
      caster.stage));
}, mana: 10, cooldown: 200);

Spell healSpell = new Spell((Being caster) {
  caster.hp += 1;
}, mana: 1, cooldown: 10,
possible: (Being caster) => caster.hp < caster.hpmax);

Spell spawnSpell = new Spell((Being caster) {
  // spawns an enemy at the caster's location
  caster.stage.actors.add(new RandEnemy(caster.x,caster.y,caster.stage));
}, mana: 30, cooldown: 1000);
