// file: npc.dart
// contains: NPC

part of common;

Hero hero;

class NPC extends Being {
  // Basic NPC format
  
  bool killable; // if the NPC can be killed
  String name; // Name of the NPC
  
  NPC(x,y,base) : super(x,y,base) {
    name = "Ro"; // temp
    width = 20;
    height = 20;
    color = "lightblue";
    target = this;
    killable = false;
  }
  
  void update(dt) {
    if (hp <= 0 && killable) dead = true; // check if NPC is killed
    
    super.update(dt);
  }
  
  void interact(Hero hero) {
    //hero.conv = true;
  }

  //==== PACKING ====
  // Packing basic NPC things
  NPC.fromPack(data) : super.fromPack(data);
}