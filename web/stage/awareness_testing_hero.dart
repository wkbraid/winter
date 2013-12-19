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
    if(atEdge())
      color = "yellow";
    else
      color = 'purple';
    if(againstWall())
      bordercolor = "red";
    else
      bordercolor = 'purple';
    super.update();
  }
  
  bool atEdge(){
    if(down){
      if(stage.map.data[ry+1][rx] == 0 || stage.map.data[ry+1][rx-1] == 0  || stage.map.data[ry+1][rx+1] == 0 )
        return true;
    }
    return false;
  }
  bool againstWall(){
    if(stage.map.data[ry][rx-1] == 1 || stage.map.data[ry][rx+1] == 1)
      return true;
    return false;
  }
}