// file: gui.dart
library gui;

import 'dart:html';

class Gui {
  //Handles the graphical user interface
  void login(callback) {
  querySelector("#logMeIn").onClick.listen((e) { callback(querySelector("#textfield").value);
  print(querySelector("#textfield").value == "fred");
  print(querySelector("#textfield").value);
    });
  }
}