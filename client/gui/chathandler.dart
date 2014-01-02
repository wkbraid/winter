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
    
    input.onChange.listen(handleInput);
    add("Hello World");
  }
  
  void add(String msg) {
    output.appendHtml("$msg<br />");
    output.scrollTop = 100000;
  }
  
  void handleInput(e) {
    send({"cmd": "chat","msg":"say ${input.value}"});
    input.value = "";
  }
}