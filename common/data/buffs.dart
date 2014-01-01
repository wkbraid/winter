// file: buffs.dart

part of common;

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