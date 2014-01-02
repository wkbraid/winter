// file: spells.dart

part of common;

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