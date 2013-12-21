// file: awareness_testing_hero.dart
// This is a testing class being used to tinker with map awareness functions.
part of stage;

class ATHero extends Hero{
  
  
  //default constructor
  ATHero(x,y,stage) : super(x,y,stage){
    color = 'purple';
  }
  
  void update(){
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
      if(stage.map.get(x,y+32) == 0 || stage.map.get(x,y+32) == 0  || stage.map.data[ry+1][rx+1] == 0 )
        return true;
    }
    return false;
  }
  bool againstWall(){
    if(stage.map.get(y,x-32) == 1 || stage.map.get(x+32, y) == 1)
      return true;
    return false;
  }
}