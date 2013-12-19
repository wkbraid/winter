// file: awareness_testing_hero.dart
// This is a testing class being used to tinker with map awareness functions.
part of stage;

class ATHero extends Hero{
  // rounded x and y positions scaled to tile sizes.
  num rx,ry;
  
  
  //default constructor
  ATHero(x,y,stage) : super(x,y,stage){
    rx = (x ~/ 32).abs();
    ry = (y ~/ 32).abs();
    color = 'purple';
  }
  
  void update(){
    rx = (x ~/ 32).abs();
    ry = (y ~/ 32).abs();
    
    if(down){
      if(atEdge() > 0){
        if(bigFall(atEdge()))
          color = 'red';
        else
          color = "yellow";
      }
     else
        color = 'purple';
    }
    if(againstWall() > 0){
      if(canJump(againstWall() == 2))
        bordercolor = 'green';
      else
        bordercolor = 'red';
    }
    else
      bordercolor = 'purple';
    super.update();
  }
  
  num atEdge(){
    //checks to see if of the three blocks below it is air.
    if(stage.map.data[ry+1][rx-1] == 0)
      return 1;
    else if(stage.map.data[ry+1][rx] == 0)
      return 2;
    else if(stage.map.data[ry+1][rx+1] == 0 )
      return 3;
    else
      return 0;
  }
  num againstWall(){
    // is either block next to me solid?
    if(stage.map.data[ry][rx-1] == 1)
      return 1;
    else if(stage.map.data[ry][rx+1] == 1)
      return 2;
    return 0;
  }
  
  bool canJump(bool dir){
    //takes in a number representing left or right (from againstWall),
    // then determiens if that wall is less than 4 blocks high.
    if(dir){
      if(stage.map.data[ry-1][rx+1] == 0 || stage.map.data[ry-2][rx+1] == 0 || stage.map.data[ry-3][rx+1] == 0)
        return true;
      return false;
    }
    else{
      if(stage.map.data[ry-1][rx-1] == 0 || stage.map.data[ry-2][rx-1] == 0 || stage.map.data[ry-3][rx-1] == 0)
        return true;
    return false;
    }
  }
  
  bool bigFall(num dir){
    // takes in a number representing a direction, 
    //then determines if the fall in that direction is more than 3 blocks.
    switch(dir){
      case 1:
        if(stage.map.data[ry+2][rx-1] == 0 && stage.map.data[ry-3][rx-1] == 0)
          return true;
        break;
      case 2:
        if(stage.map.data[ry+2][rx] == 0 && stage.map.data[ry-3][rx] == 0)
          return true;
        break;
      case 3:
        if(stage.map.data[ry+2][rx+1] == 0 && stage.map.data[ry-3][rx+1] == 0)
          return true;
        break;
      default:
        break;
    }
    return false;
  }
}