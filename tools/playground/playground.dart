// file: playground.dart

library playground;

import 'dart:async';
import 'dart:html';

import 'package:priority_queue/priority_queue.dart';

import '../../client/util/utils.dart';
import '../../common.dart';

part 'pathfinder.dart';

List<List<int>> tdata =
[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,1],
 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,2,2,2,2,2,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,1,1],
 [1,0,1,1,1,1,1,1,1,1,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1],
 [1,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,1,0,0,1,0,0,0,0,0,1],
 [1,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,0,0,0,0,0,1],
 [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1]];

Viewport view;
GameMap map; // The map we are testing on

int interval = 30;

Point src = new Point(1,13); // The point our path finding should start from
Point trg;

PathFinder pfinder;
List<PathAction> path = [];

void main() {
  view = new Viewport(querySelector("#area"));
  map = new GameMap("playground",[],tdata);
  pfinder = new PathFinder(map);
  
  Mouse.init();
  Keyboard.init();
  document.onMouseDown.listen(press);
  
  // start the update loop
  new Timer(new Duration(milliseconds:interval),loop);
}

void press(e) { // the mouse was pressed
  if (Keyboard.isDown(KeyCode.SHIFT)) {
    src = new Point(Mouse.x ~/ ts,Mouse.y ~/ ts);
  } else {
    trg = new Point(Mouse.x ~/ ts, Mouse.y ~/ ts);
    path = pfinder.find(src,trg); // Try to find a path from src to trg
    print(path);
  }
}

void loop() {
    
  map.update(interval);
  
  view.clear();
  view.drawInstance(map.instances.first); // draw the instance the test is on
  drawMouse();
  drawPath(path);
  
  new Timer(new Duration(milliseconds:interval),loop);
}

void drawMouse() {
  var ctx = view.ctx;
  int tx = Mouse.x ~/ ts;
  int ty = Mouse.y ~/ ts;
  ctx.strokeStyle = "darkorange";
  ctx.strokeRect(tx*ts,ty*ts,ts,ts);
}

void drawPath(List<PathAction> path) {
  var ctx = view.ctx;
  ctx.strokeStyle = "lightblue";
  ctx.beginPath();
  for (int i = 0; i < path.length; i++) {
    ctx.strokeRect(path[i].x*ts,path[i].y*ts,ts,ts);
    if (i+1 < path.length) {
      ctx.moveTo(path[i].x*ts + ts/2, path[i].y*ts + ts/2);
      ctx.lineTo(path[i+1].x*ts + ts/2, path[i+1].y*ts + ts/2);
    }
  }
  ctx.stroke();
  ctx.closePath();
}
