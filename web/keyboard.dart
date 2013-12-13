import 'dart:html';

//=========================
// keyboard.dart
//=========================

class Keyboard {
  // Keeps track of the currently pressed keys on the keyboard
  static Map _currentKeys = new Map<String, bool>();
  
  static void init() {
    // initialize keyboard events.
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