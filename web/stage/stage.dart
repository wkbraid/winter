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
    var rand = new Random();
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
    actors.removeWhere((act) => act.dead());
    
    // update the other actors
    for (Actor act in actors) {
        act.update();
    }
    
    // actor-actor collision
    for (Actor act1 in actors) {
      for (Actor act2 in actors) {
        // check for collision
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