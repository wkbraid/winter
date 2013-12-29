// file: inanimate.dart
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
  void open(Hero opener) {
    // open the portal and go through it
    opener.mapid = targmap;
    opener.x = targx;
    opener.y = targy;
  }
}


class Pickupable extends Inanimate {
  Item item;
  
  Pickupable(x,y,item) : super(x,y) {
    this.item = item;
    color = item.color;
  }
}