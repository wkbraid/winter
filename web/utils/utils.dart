// file: utils.dart
library utils;
import 'dart:html';
import '../stage/stage.dart';
part 'viewport.dart';

//============================================================
// Keyboard
//============================================================

class Keyboard {
  // Keeps track of the currently pressed keys on the keyboard
  static Map _currentKeys = new Map<String, bool>();
  
  static void init() {
    // listen for keyboard events
    document.onKeyDown.listen(_keyPressed);
    document.onKeyUp.listen(_keyReleased);
  }
  
  static bool isDown(int keyCode) => _currentKeys.containsKey('$keyCode');
  static bool isAnyDown() => _currentKeys.isEmpty;
  
  static void _keyPressed(KeyboardEvent e) {
    _currentKeys['${e.keyCode}'] = true;
  }
  
  static void _keyReleased(KeyboardEvent e) {
    _currentKeys.remove('${e.keyCode}');
  }
}

//============================================================
// Mouse
//============================================================

class Mouse {
  // keep track of the current position and whether the mouse is pressed
  static bool down = false;
  static num x, y;
  static var canvas;
  
  static void init() {
    // start listening for mouse events
    canvas = querySelector("#area");
    document.onMouseMove.listen(_moved);
    document.onMouseDown.listen(_pressed);
    document.onMouseUp.listen(_released);
  }
  
  static void _moved(MouseEvent e) {
    var rect = canvas.getBoundingClientRect();
    x = e.client.x - rect.left;
    y = e.client.y - rect.top;
  }
  
  static void _pressed(MouseEvent e) {
    down = true;
  }
  
  static void _released(MouseEvent e) {
    down = false;
  }
}