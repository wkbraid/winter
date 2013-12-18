import 'dart:html';
import '../web/stage/stage.dart';
import '../web/utils/utils.dart';
import 'dart:convert';

GameMap map;
Viewport view;

num current = 1;

// save and load data to the text area
void saveData(MouseEvent e) { querySelector("#output").setInnerHtml(JSON.encode(map.data)); }
void loadData(MouseEvent e) { map.data = JSON.decode(querySelector("#output").value);  }

void main() {
  var canvas = querySelector("#area");
  view = new Viewport(canvas);
  view.x = 0;
  view.y = 0;
  map = new GameMap([[1,1,1,1,1]],view);
  map.data = [[1,0,1]];
  
  querySelector("#output").innerHtml = JSON.encode(map.data);
  
  Keyboard.init();
  Mouse.init();
  
  // allow data to be saved and loaded via the textarea
  querySelector("#save").onClick.listen(saveData);
  querySelector("#load").onClick.listen(loadData);
  
  // set up the gui listeners
  querySelector("#growleft").onClick.listen(growleft);
  querySelector("#growright").onClick.listen(growright);
  querySelector("#growup").onClick.listen(growup);
  querySelector("#growdown").onClick.listen(growdown);
  
  querySelector("#shrinkleft").onClick.listen(shrinkleft);
  querySelector("#shrinkright").onClick.listen(shrinkright);
  querySelector("#shrinkup").onClick.listen(shrinkup);
  querySelector("#shrinkdown").onClick.listen(shrinkdown);

  querySelector("#current0").onClick.listen((e) { current = 0;});
  querySelector("#current1").onClick.listen((e) { current = 1;});
  
  
  
  // start the editor loop
  window.requestAnimationFrame(loop);
}

// map growing
void growleft(MouseEvent e) { 
  for (var row in map.data) {
    row.insert(0,current);
  }
}
void growright(MouseEvent e) {
  for (var row in map.data){
    row.add(current);
  }
}
void growup(MouseEvent e) {
  map.data.insert(0, new List.generate(map.data[0].length,(i) => current));
}
void growdown(MouseEvent e) {
  map.data.add(new List.generate(map.data[0].length,(i) => current));
}

// map shrinking
void shrinkleft(MouseEvent e) {
  for (var row in map.data)
    row.removeAt(0);
}
void shrinkright(MouseEvent e) {
  for (var row in map.data)
    row.removeLast();
}
void shrinkup(MouseEvent e) {
  map.data.removeAt(0);
}
void shrinkdown(MouseEvent e) {
  map.data.removeLast();
}

void loop(num time) {
  // clear the viewport
  view.guicontext.clearRect(0, 0, view.width, view.height);
  
  if (Keyboard.isDown(KeyCode.M)) { // Grow
    if (Keyboard.isDown(KeyCode.D)) growright(null);
    if (Keyboard.isDown(KeyCode.A)) growleft(null);
    if (Keyboard.isDown(KeyCode.W)) growup(null);
    if (Keyboard.isDown(KeyCode.S)) growdown(null);
  } else if (Keyboard.isDown(KeyCode.N)) { // shrink
    if (Keyboard.isDown(KeyCode.D)) shrinkright(null);
    if (Keyboard.isDown(KeyCode.A)) shrinkleft(null);
    if (Keyboard.isDown(KeyCode.W)) shrinkup(null);
    if (Keyboard.isDown(KeyCode.S)) shrinkdown(null);
  } else { // scroll
    if (Keyboard.isDown(KeyCode.D)) view.x += 10;
    if (Keyboard.isDown(KeyCode.A)) view.x -= 10;
    if (Keyboard.isDown(KeyCode.W)) view.y -= 10;
    if (Keyboard.isDown(KeyCode.S)) view.y += 10;
  }
  
  // select current
  if (Keyboard.isDown(KeyCode.ZERO)) current = 0;
  if (Keyboard.isDown(KeyCode.ONE)) current = 1;
  
  // save data to textarea
  if (Keyboard.isDown(KeyCode.Z)) saveData(null);
  
  // update map based on mouse clicks
  if (Mouse.down) {
    if (Mouse.x > 0 && Mouse.x < view.width && Mouse.y > 0 && Mouse.y < view.height) {
      num tx, ty;
      // annoying flooring problems, really want to round towards zero
      if (view.x + Mouse.x < 0) tx = ((Mouse.x + view.x) ~/ map.ts) - 1;
      else tx = tx = (Mouse.x + view.x) ~/ map.ts;
      if (view.y + Mouse.y < 0) ty = ((Mouse.y + view.y) ~/ map.ts) - 1;
      else ty = (Mouse.y + view.y) ~/ map.ts;
      
      if (tx >= 0 && tx < map.data[0].length && ty >= 0 && ty < map.data.length) 
        map.data[ty][tx] = current;
    }
  }
  
  map.draw();
  drawMouse();
  window.requestAnimationFrame(loop);
}

void drawMouse() {
  var ctx = view.viewcontext;
  ctx.strokeStyle = "darkorange";
  num tx, ty;
  // annoying flooring problems, really want to round towards zero
  if (view.x + Mouse.x < 0) tx = ((Mouse.x + view.x) ~/ map.ts) - 1;
  else tx = tx = (Mouse.x + view.x) ~/ map.ts;
  if (view.y + Mouse.y < 0) ty = ((Mouse.y + view.y) ~/ map.ts) - 1;
  else ty = (Mouse.y + view.y) ~/ map.ts;
  ctx.strokeRect(tx*map.ts,ty*map.ts,map.ts,map.ts);
}