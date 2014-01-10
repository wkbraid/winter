// file: convhandler.dart
// contains:ConvHandler

part of server;

class ConvHandler {
  // Handles npc interactions between a Client on the server and the client's Gui
  
  var send; // send function taken from Client
  Hero hero; // The hero to allow inventory/quest manipulation
  Map conversation;
  Conversation activeConv;
  
  ConvHandler(this.hero, this.send) {
   // add(new Conversation()); // send a test conversation
    conversation = getConversation();
  }
  
  Map getConversation(){
    var file = new File('conversations.json');
    String jsonConversation = file.readAsStringSync();
    Map convTemp = JSON.decode(jsonConversation);
    return convTemp['dialog']; 
  }
  
  // Receive data from the client, filtered by the Client class for relevance
  void receive(data) {
    print("ConvHandler received data: $data");
  }
  
  void add(Conversation conv) {
    // (Could also just take in an id and load the conversation from a db)
    conv.addConversation(conversation);
    print("Sending");
    send({"cmd":"npc","message":activeConv.retrieveMessage(),"responses":activeConv.retrieveChoices()});
  }
}