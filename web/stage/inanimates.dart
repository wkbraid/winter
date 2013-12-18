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

class Pickupable extends Inanimate {
  Item item;
  
  Pickupable(x,y,item,stage) : super(x,y,stage) {
    this.item = item;
  }
}