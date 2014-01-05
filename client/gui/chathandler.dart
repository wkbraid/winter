// file: chathandler.dart
// contains: ChatHandler

part of client;

class ChatHandler {
  
  DivElement output;
  InputElement input;
  
  var send; // Send function taken from gui
  
  ChatHandler(String inclass, String outclass, this.send) {
    output = querySelector(".$outclass");
    input = querySelector(".$inclass");
    
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