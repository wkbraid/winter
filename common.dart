// file: common.dart
library common;

import 'dart:math';

part 'common/account.dart';
part 'common/constants.dart';
part 'common/actor.dart';
part 'common/gamemap.dart';
part 'common/spell.dart';
part 'common/enemy.dart';
part 'common/projectile.dart';

class Sync {
  // Base class for all objects which will be synced across the server
  Sync(); // Basic constructor for inheritance
  Sync.fromPack(dynamic data) { } // Create the object from recieved changes
  dynamic pack() { } // pack changes to be sent
  void unpack(dynamic data) { } // unpack changes recieved
}