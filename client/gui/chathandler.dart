// file: chathandler.dart
// contains: ChatHandler

part of gui;

class ChatHandler {
  
  DivElement output;
  InputElement input;
  
  var send; // Send function taken from gui
  
  ChatHandler(String inid, String outid, this.send) {
    output = querySelector("#$outid");
    input = querySelector("#$inid");
    add("Hello World");
  }
  
  void add(String msg) {
    output.appendHtml("$msg<br />");
  }
}