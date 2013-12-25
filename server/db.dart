// file:db.dart

//========================================================
// Main Database
//========================================================
// Fake database until a real one exists

import '../common.dart';

// Accounts indexed by username
Map<String,Account> accs = {
  "knarr" : new Account("knarr", 
      new Character("test1",50,50,
      new Stats(speed: 20/1000)))
};