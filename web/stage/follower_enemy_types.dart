// file: follow_enemy_types.dart
// This file contains enemies with following AIs.
part of stage;

class FollowerEnemy1 extends Enemy {
  // This is a following testing AI creature
  // The actor the enemy is trying to follow
  Actor target;
  //default constructor
  FollowerEnemy1(x,y,stage,Actor) : super(x,y,stage) {
    super.color = "blue";
    super.bordercolor = 'blue';
    width = 30;
    height = 30;
    target = Actor; // sets inputted actor as target
  } 
  void update() {
    var rand = new Random();
    // if target's alive, follow it, otherwise die.
    if(target.dead)
      dead = true;
    
    if (target.x > this.x)
      vx += 0.1;
    else
      vx -= 0.1;
    if (vx.abs() < 0.5 && down) // jump if moving slowly (bad collision detection)
      vy -= 18;
    
    super.update();
  }
}

class FollowerEnemy2 extends Enemy{
  Actor target;
  num movePattern,oldX,oldY;
  //default constructor
  FollowerEnemy2(x,y,stage,Actor) : super(x,y,stage) {
    width = 25;
    height = 30;
    target = Actor;
    super.color = 'orange';
    super.bordercolor = 'blue';
    movePattern = 1;
    oldX = x;
    oldY = y;
  }
  
  void update(){
    //This switch statement determines what action it takes
    // 1 is the default follow
    // 2 is a decision making period after a jump from pattern 1
    // leads to pattern 3 or 5
    // 3 means it's backing up in an attemp to gain altitude
    // 4 was incorporated into 3, might add again later.
    // 5 is an attempt to lower its y position.
    
    switch(movePattern){
      case 1: //basic following
        if (target.x > x)
          vx += 0.1;
        else
          vx -= 0.1;
        if (vx.abs() < 0.5){
          if(down){
            vy -= 18;
            movePattern = 2;
            oldX = x;
          }
        }
        break;
        
      case 2:
        if (target.x > this.x)
          vx += 0.1;
        else
          vx -= 0.1;
        if(down)
          if((oldX - x).abs() < 5){
            if(target.y < y){
              movePattern = 3;
              oldX = x;
              oldY = y;
            }
            else{
              movePattern = 5;
              oldX = x;
              oldY = target.y;
            }
          }
          else
            movePattern = 1;
        break;
        
      case 3:
        if (target.x > this.x)
          vx -= 0.2;
        else
          vx += 0.2;
        if(down){
          if((oldX - x).abs() > 200 || (oldY - y).abs() > 20 || vx == 0){
            if(target.x > this.x){
              vx += 12;
              vy -= 18;
            }
            else{
              vx -= 12;
              vy -= 18;
            }
          movePattern = 1;
        }
          else{
            vy -= 18;
          }
        }
        break;
       
      case 5:
        if (target.x > this.x)
          vx -= 0.1;
        else
          vx += 0.1;
        if(down){
          if(oldY <= y || vx.abs() < 0.2)
            movePattern = 1;
        } 
        break;
        
      default:
        break;
      }
    super.update();
  }
}

class FollowerEnemy3 extends Enemy{
  // This one implements some basic map awareness functions
  Actor target;
  num movePattern,rx,ry;
  //default constructor
  FollowerEnemy3(x,y,stage,Actor) : super(x,y,stage) {
    width = 25;
    height = 30;
    target = Actor;
    super.color = 'orange';
    super.bordercolor = 'blue';
    movePattern = 1;
    rx = (x ~/ 32).abs();
    ry = (y ~/ 32).abs();
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