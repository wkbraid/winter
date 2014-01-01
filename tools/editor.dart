// file: editor.dart

import 'dart:html';
import 'dart:convert';
import 'dart:async';

import '../client/util/utils.dart';
import '../common.dart';

Viewport view;

int interval = 30; // how often we should re-draw

int twidth = 27; // number of horizontal tiles
int theight = 15;

int select = 0; // Currently selected tile

// 0 - point, 1 - fill
int mode = 0; // The edit mode we are in

int tx,ty; // mouse position in tiles

List<List<int>> tdata;

void main() {
  // set up the viewport
  view = new Viewport(querySelector("#area"));
  
  tdata = new List.generate(theight, (int i) =>
            new List.filled(twidth,select)); // fill the map
  
  saveData(null); // save the data to the map
  
  // allow data to be saved and loaded via buttons
  querySelector("#save").onClick.listen(saveData);
  querySelector("#load").onClick.listen(loadData);
  
  // Set up user interaction
  Keyboard.init();
  Mouse.init();
  
  // start the update loop
  new Timer(new Duration(milliseconds:interval),loop);
}

void loop() {
  tx = Mouse.x ~/ ts; // update the mouse position
  ty = Mouse.y ~/ ts;
  
  // change selection
  if (Keyboard.isDown(KeyCode.ZERO)) select = 0;
  if (Keyboard.isDown(KeyCode.ONE)) select = 1;
  if (Keyboard.isDown(KeyCode.TWO)) select = 2;
  if (Keyboard.isDown(KeyCode.THREE)) select = 3;
  if (Keyboard.isDown(KeyCode.FOUR)) select = 4;
  if (Keyboard.isDown(KeyCode.FIVE)) select = 5;
  if (Keyboard.isDown(KeyCode.SIX)) select = 6;
  if (Keyboard.isDown(KeyCode.SEVEN)) select = 7;
  if (Keyboard.isDown(KeyCode.EIGHT)) select = 8;
  if (Keyboard.isDown(KeyCode.NINE)) select = 9;
  
  // change mode
  if (Keyboard.isDown(KeyCode.P)) mode = 0; // point
  if (Keyboard.isDown(KeyCode.F)) mode = 1; // fill
  
  if (Mouse.down && tx >= 0 && tx < twidth && ty >= 0 && ty < theight) {
    // We have the mouse down inside the map
    if (mode == 0) // point
      tdata[ty][tx] = select;
    else if (mode == 1) {// fill
      mode = 0;
      fill(tx,ty,tdata[ty][tx],select);
    }
  }
  
  view.clear();
  view.drawTiles(tdata);
  drawMouse();
  
  new Timer(new Duration(milliseconds:interval),loop);
}

void fill(int x, int y, int from, int to) {
  // fill starting from x,y all tiles of number from with to
  if (from != to && x >= 0 && x < twidth && y >= 0 && y < theight
      && tdata[y][x] == from) {
    tdata[y][x] = to;
    fill(x+1,y,from,to);
    fill(x-1,y,from,to);
    fill(x,y+1,from,to);
    fill(x,y-1,from,to);
  }
}

void drawMouse() {
  var ctx = view.ctx;
  ctx.strokeStyle = "darkorange";
  ctx.strokeRect(tx*ts,ty*ts,ts,ts);
}

// save and load data to the text area
void saveData(MouseEvent e) { querySelector("#output").setInnerHtml(JSON.encode(tdata)); }
void loadData(MouseEvent e) { TextAreaElement txt = querySelector("#output"); tdata = JSON.decode(txt.value);  }
