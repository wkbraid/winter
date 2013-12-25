// file: hero.dart
part of stage;

class Hero extends Player {
  // This client's hero
  // augments other client's players with keyboard control and movement
  
  Character char; // The character which the hero embodies
  
  // The Hero is closely linked to a character
  num get x => char.x; void set x(num x) { char.x = x; }
  num get y => char.y; void set y(num y) { char.y = y; }
  Stats get stats => char.stats; void set stats(Stats s) { char.stats = s; }
  
  Hero(this.char) {
    //print(char.pack());
    color = "blue";
    width = 20;
    height = 20;
  }
  
  void update(num dt) {
    // work out acceleration of the hero
    if (Keyboard.isDown(KeyCode.A)) vx -= stats.speed*dt;
    if (Keyboard.isDown(KeyCode.D)) vx += stats.speed*dt;
    if (Keyboard.isDown(KeyCode.W)) vy -= stats.speed*dt;
    if (Keyboard.isDown(KeyCode.S)) vy += stats.speed*dt;
    super.update(dt);
  }
  
  // packing - to the server the hero is just a character associated with a player
  pack() {
    return {
      "char" : char.pack(),
      "player" : super.pack()
    };
  }
  unpack(data) {
    // NB: char and player share x,y this could be problems
    char.unpack(data["char"]);
    super.unpack(data["player"]);
  }
}