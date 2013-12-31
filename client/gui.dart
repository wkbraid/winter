// file: gui.dart
library gui;

import 'dart:html';

class Gui {
  //Handles the graphical user interface
  void login(callback) {
    querySelector("#logMeIn").onClick.listen((e) {
      InputElement tf = querySelector("#textfield");
      callback(tf.value);
    });
  }
}