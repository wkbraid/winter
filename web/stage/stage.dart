// file: stage.dart
library stage;
import 'dart:html';
import '../utils/utils.dart';
import 'dart:math';
import '../utils/constants.dart';
import '../user/account.dart';
part 'map.dart';
part 'actors.dart';
part 'enemies.dart';
part 'hero.dart';
part 'projectiles.dart';
part 'spells.dart';
part 'inanimates.dart';
part 'items.dart';
part 'awareness_testing_hero.dart';
part 'follower_enemy_types.dart';


class Stage {
  // The non-gui part of the game, containing the map and all actors
  Viewport view;
  GameMap map;
  Hero hero;
  List<Actor> actors = [];
  
  Stage(account,view) {
    this.view = view;
    loadHero(account); // load the hero from the account info
    loadMap(hero.mapid); // load the map the hero is on

    this.view.follow(hero); // set the viewport to follow the hero
  }
  
  // Load a hero from an account
  void loadHero(Account acc) {
    // dummy interface, should later load from files and/or server
    if (acc.username == "knarr")
      hero = new ATHero(50,450,this);
    else
      hero = new Hero(100,450,this);
  }
  // add an actor to the stage
  void addActor(Actor act) {
    map.actors.add(act);
  }
  
  // Load the map from a given mapid
  void loadMap(String mapid) {
    // dummy interface, should later load from files and/or server
    List<List> mdata;
    if (mapid == "miles1") {
      mdata =
          [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
           [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
           [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
           [1,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,1,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
           [1,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,1,1,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
           [1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1],
           [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
           [1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
           [1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
           [1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
           [1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
           [1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
           [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
      map = new GameMap(mdata, this.view);
      map.actors.add(new FollowerEnemy2(100,450,this,hero));
      map.actors.add(new RandEnemy(100,450,this));
      map.actors.add(new FlyingEnemy(100,300,this));
      map.actors.add(new Pickupable(120,400,new HealthPotion(),this));
      map.actors.add(new Pickupable(200,400,new HealthPotion(),this));
      map.actors.add(new Pickupable(500,400,new ManaPotion(),this));
      map.actors.add(new Pickupable(550,220,new SkiGoggles(),this));
    } else {
      mdata = [[1,1,1,1,1,1,1,1,1,1,1,1],
               [1,0,0,0,0,0,0,0,0,0,0,1],
               [1,0,0,0,0,0,0,0,0,0,0,1],
               [1,0,0,0,0,0,0,0,0,1,0,1],
               [1,0,0,0,0,0,0,0,0,1,0,1],
               [1,0,0,1,0,0,1,0,0,1,0,1],
               [1,0,0,0,0,0,0,1,0,0,0,1],
               [1,1,0,0,0,0,0,0,0,0,0,1],
               [1,1,0,0,0,0,0,0,0,0,1,1],
               [1,1,0,0,0,0,0,0,0,0,0,1],
               [1,1,1,1,1,1,0,0,0,0,0,1],
               [1,1,1,1,1,1,1,1,1,1,1,1]];
      map = new GameMap(mdata, this.view);
      map.actors.add(new Pickupable(110,100,new ManaPotion(),this));
      map.actors.add(new ShootyEnemy(200,200,this));
    }
  }
  
  void update() {
    hero.update(); // update the hero
    map.update(); // update the map
    map.checkCollisions(hero); // check for collisions with the hero
  }
  
  void draw() {
    // draw the map and hero
    map.draw();
    hero.draw(); // might want some things to be drawn after hero...
  }
}