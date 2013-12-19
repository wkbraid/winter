// file: inanimates.dart
part of stage;

class Inanimate extends Actor {
  
  Inanimate(x,y,stage) : super(x,y,stage) {
    color = "orange";
    bordercolor = "darkorange";
    height = 5;
    width = 15;
  }
}

//==========================================
// Common Inanimates
//==========================================
class Portal extends Inanimate {
  num targx, targy; // the end position of going through the portal
  
  Portal(x,y,targx,targy,stage) : super(x,y,stage) {
    height = 30;
    width = 30;
    this.targx = targx;
    this.targy = targy;
  }
  void collide(Actor other) {
    // teleport anything which touches the portal
    other.x = targx;
    other.y = targy;
  }
}


class Pickupable extends Inanimate {
  Item item;
  
  Pickupable(x,y,item,stage) : super(x,y,stage) {
    this.item = item;
  }
}