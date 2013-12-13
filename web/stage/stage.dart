// file: stage.dart
library stage;
import 'dart:html';
import '../utils/utils.dart';
part 'map.dart';
part 'actors.dart';
part 'hero.dart';


class Stage {
  // The non-gui part of the game, containing the map and all actors
  Viewport view;
  GameMap map;
  Actor hero;
  
  Stage(mdata,view) {
    this.view = view;
    map = new GameMap(mdata,this.view);
    hero = new Hero(map,50,50,0,0);
    this.view.follow(hero);
  }
  
  void update() {
    // update the hero
    hero.update();
  }
  
  void draw() {
    // draw the map and hero
    map.draw();
    hero.draw();
  }
}