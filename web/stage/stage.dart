// file: stage.dart
library stage;
import 'dart:html';
import '../utils/utils.dart';
import 'dart:math';
part 'map.dart';
part 'actors.dart';
part 'hero.dart';
part 'projectiles.dart';


class Stage {
  // The non-gui part of the game, containing the map and all actors
  Viewport view;
  GameMap map;
  Hero hero;
  List<Actor> actors = [];
  
  Stage(mdata,view) {
    this.view = view;
    map = new GameMap(mdata,this.view);
    hero = new Hero(50,650,this);
    
    actors.add(new FlyingEnemy(50,600,this));
    actors.add(new RandEnemy(100,650,this));
    actors.add(new RandEnemy(900,650,this));
    actors.add(new RandEnemy(400,900,this));
    actors.add(new RandEnemy(200,50,this));
    this.view.follow(hero);
  }
  
  
  void update() {
    // update the hero
    hero.update();
    // remove all the dead actors
    actors.removeWhere((act) => act.dead);
    
    // update the other actors
    for (Actor act in actors) {
        act.update();
    }
    
    // actor-actor collision
    for (var i = 0; i < actors.length; i++) {
      Actor act1 = actors[i];
      // independently check for hero collisions? this seems terrible
      if (hero.x - hero.width/2 < act1.x + act1.width/2
          && hero.x + hero.width/2 > act1.x - act1.width/2
          && hero.y - hero.height/2 < act1.y + act1.height/2
          && hero.y + hero.height/2 > act1.y - act1.height/2) {
          
          hero.collide(act1);
          act1.collide(hero);
        }
      for (var j = i+1; j < actors.length; j++) {
        Actor act2 = actors[j];
        // check for collision
        if (act1.x - act1.width/2 < act2.x + act2.width/2
          && act1.x + act1.width/2 > act2.x - act2.width/2
          && act1.y - act1.height/2 < act2.y + act2.height/2
          && act1.y + act1.height/2 > act2.y - act2.height/2) {
          act1.collide(act2);
          act2.collide(act1);
        }
      }
    }
  }
  
  void draw() {
    // draw the map and hero
    map.draw();
    hero.draw();
    // draw all other actors
    for (Actor act in actors) {
      act.draw();
    }
  }
}