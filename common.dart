// file: common.dart
// contains: 
library common;

import 'dart:math';
import 'dart:async';

import 'packages/priority_queue/priority_queue.dart';

part 'common/constants.dart';
part 'common/account.dart';
part 'common/spell.dart';
part 'common/item.dart';
part 'common/stats.dart';
part 'common/quest.dart';
part 'common/conversation.dart';

// Ai related stuff
part 'common/ai/pathfinder.dart';

// Specific item/spell/buff references
part 'common/data/items.dart';
part 'common/data/spells.dart';
part 'common/data/buffs.dart';
part 'common/data/enemies.dart';

// Map related files
part 'common/map/gamemap.dart';
part 'common/map/instance.dart';
part 'common/map/mobspawner.dart';

part 'common/map/actor/actor.dart';
part 'common/map/actor/enemy.dart';
part 'common/map/actor/projectile.dart';
part 'common/map/actor/inanimate.dart';
part 'common/map/actor/hero.dart';
part 'common/map/actor/npc.dart';