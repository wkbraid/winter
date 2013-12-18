// file: spells.dart
part of stage;

class Spell {
  // The base class for all spells castable by actors
  num cooldown = 500; // cooldown in miliseconds
  DateTime lastcast; // last time when the spell was cast 
  num mana = 5; // mana cost
  var effects;
  
  Spell(this.effects, {this.mana, this.cooldown}) {
    lastcast = new DateTime.now();
  }
  
    
  
  num cast(Being by) { // cast the spell
    if (-lastcast.difference(new DateTime.now()).inMilliseconds > cooldown) {
      lastcast = new DateTime.now();
      effects(by); // cast the spell effects
      return mana;
    }
    return 0; // otherwise the spell didn't cast
  }
}

//===========================================
// Game Spells
//===========================================
Spell pelletSpell = new Spell((Being by) {
  num posx = by.stage.view.width/2;
  num posy = by.stage.view.height/2;
  num dist = sqrt(pow(posx-Mouse.x,2)+pow(posy - Mouse.y, 2));
  by.stage.actors.add(new Projectile(by.x,by.y,
      by.vx + (Mouse.x - posx)*20/dist,
      by.vy + (Mouse.y - posy)*20/dist,
      by.stage));
}, mana: 10, cooldown: 200);