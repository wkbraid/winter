// file: actors.dart
part of stage;

class Being extends Actor {
  // High level Actor subclass of beings containing
  // basic stats such as hp
  
  String mapid = "miles1"; // the map we are currently on
  
  List<Buff> buffs = []; // Buffs currently affecting this player
    // should be made into a heap eventually
  
  Map<String,Spell> spells = {}; // the spells which can be cast by this being
  
  num hpmax = 100;
  num hp = 100;
  num mp = 0;
  num mpmax = 100;
  
  
  Being(x,y,stage) : super(x,y,stage);
  
  void update() {
    super.update();
    buffs.removeWhere((buff) => buff.duration <= 0); // clear finished buffs
    for (Buff buff in buffs) { // update buffs
      buff.update();
    }
  }
  
}

class Actor {
  // Base class for all map dwellers

  Stage stage; // The stage the actor is on
  bool dead = false; // Is the actor dead?
  bool down = false; // Is there something below the actor, should be moved eventually

  String color,bordercolor; // Simple description needed to draw the actor
  
  num x,y,width,height; // The dimensions of the actor, (x,y) is at the center of the Actor
  num vx = 0,vy = 0; // The horizontal and vertical components of the actor's velocity
  
  Actor(this.x,this.y, this.stage);
  
  // Placeholder functions
  void collide(Actor other) { } // The actor collided with other
  
  // default draw function
  void update() {
    vy += g; // gravity
    vx *= mu; // friction
    vy *= mu;
    move(vx,vy); // move the enemy
  }
  void draw() {
    var context = stage.view.viewcontext; // get the context from the stage we are on
    context.fillStyle = color;
    context.lineWidth = 2;
    context.strokeStyle = bordercolor;
    context.fillRect(x-width/2, y-height/2, width, height);
    context.strokeRect(x-width/2, y-height/2, width, height);
  }
  
  // default functions
  void move(num dx, num dy) { // move the actor by dx,dy
    down = false; // reset the ground status
    
    if (dx > 0 && sumHorz(x+dx+width/2) != 0)
      dx = collideX(dx); // collide right
    if (dx < 0 && sumHorz(x+dx-width/2) != 0)
      dx = collideX(dx); // collide left
    
    if (dy > 0 && sumVert(y+dy+height/2) != 0)
      dy = collideY(dy);
    if (dy < 0 && sumVert(y+dy-height/2) != 0)
      dy = collideY(dy);
    
    x += dx; // move the hero
    y += dy;
  }
  num collideX(num dx) { // collide with a wall in the x direction
    vx = 0;
    return 0;
  }
  num collideY(num dy) { // collide with a wall in the y direction
    if (dy > 0) down = true;
    vy = 0;
    return 0;
  }
  
  // sum over the map coordinates along the ypos along the edge along the width of the actor
  num sumVert(ypos) {
    num sum = 0;
    for (num xpos = x - width/2; xpos < x + width/2; xpos += stage.map.ts/2) {
      sum += stage.map.get(xpos, ypos);
    }
    return sum + stage.map.get(x + width/2, ypos);
  }
  
  // sum over the map coordinates along the xpos along the edge along the height of the actor
  num sumHorz(xpos) {
    num sum = 0;
    for (num ypos = y - height/2; ypos < y + height/2; ypos += stage.map.ts/2) {
      sum += stage.map.get(xpos, ypos);
    }
    return sum + stage.map.get(xpos,y+height/2);
  }
}

