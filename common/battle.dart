// file: battle.dart
part of common;

class Battle extends GameMap {
  // Stores information about a fight between two teams,
  // Similar to map in that it is self-contained
  
  List<Being> teamA = []; // The contestants
  List<Being> teamB = [];

  // Create a copy of the map with no actors
  Battle(GameMap map) : super(map.id,[],map.tdata) {
    
  }
  
  bool addActor(Actor act, {team:"A"}) {
    
  }
}