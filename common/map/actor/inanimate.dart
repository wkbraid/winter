// file: inanimate.dart
// contains: Inanimate, Portal, Pickupable

part of common;

class Inanimate extends Actor {
  
  Inanimate(x,y) : super(x,y) {
    color = "purple";
    height = 5;
    width = 15;
  }
}

//==========================================
// Common Inanimates
//==========================================
class Portal extends Inanimate {
  num targx, targy; // the end position of going through the portal
  String targmap; // the map we are going to
  
  Portal(x,y,targx,targy,targmap) : super(x,y) {
    height = 30;
    width = 30;
    this.targx = targx;
    this.targy = targy;
    this.targmap = targmap;
  }
  void interact(Hero hero) {
    // open the portal and go through it
    hero.mapid = targmap;
    hero.x = targx;
    hero.y = targy;
  }
}


class Pickupable extends Inanimate {
  Item item;
  
  Pickupable(x,y,item) : super(x,y) {
    this.item = item;
    color = item.color;
  }
  
  // kills the actor copy of the item, 
  // then places pickupable thing in hero's inventory
  // and immediately equips if possible.
  void interact(Hero hero){
    dead = true;
    hero.inv.put(item);
    if(item is Equipable){
      hero.inv.equip(item);
    }
  }
}

class Bank extends Inanimate {
  // actor that's interacted with to access your bank inventory
  Bank(x, y) : super(x,y){
    height = 30;
    width = 60;
    color = "gold";
  }
  
  void interact(Hero hero){
    hero.overlay = 1;
  }
}