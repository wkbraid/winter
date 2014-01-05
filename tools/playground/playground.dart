// file: playground.dart

library playground;

import 'dart:async';
import 'dart:html';


import '../../client/util/utils.dart';
import '../../common.dart';

List<List<int>> tdata =
[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,1,0,0,1,0,0,0,0,1,1],
 [1,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,0,0,0,0,0,1],
 [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];

Viewport view;
GameMap map; // The map we are testing on

int interval = 30;

Point trg;

PathFinder pfinder;
PathEnemy test;

void main() {
  view = new Viewport(querySelector("#area"));
  test = new PathEnemy(45,405,new Stats(hpmax:10));
  map = new GameMap("playground",[test],tdata);
  pfinder = new PathFinder(map);
  
  Mouse.init();
  Keyboard.init();
  document.onMouseDown.listen(press);
  
  // start the update loop
  new Timer(new Duration(milliseconds:interval),loop);
}

void press(e) { // the mouse was pressed
  if (Keyboard.isDown(KeyCode.SHIFT)) {
    Point src = new Point(Mouse.x ~/ ts,Mouse.y ~/ ts);
    test.x = src.x*ts + ts/2;
    test.y = src.y*ts + ts/2;
  } else {
    trg = new Point(Mouse.x ~/ ts, Mouse.y ~/ ts);
    test.path = pfinder.find(new Point(test.x ~/ ts, test.y ~/ ts),trg); // Try to find a path from src to trg
  }
}

void loop() {
    
  map.update(interval);
  
  view.clear();
  view.drawInstance(map.instances.first); // draw the instance the test is on
  drawMouse();
  drawPath(test.path);
  
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
