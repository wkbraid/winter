// file: npchandler.dart
// contains: NpcHandler, Conversation

part of common;

class NpcHandler {
  // Handles npc interactions between a Client on the server and the client's Gui
  
  var send; // send function taken from Client
  Hero hero; // The hero to allow inventory/quest manipulation
  
  NpcHandler(this.hero, this.send) {
   // add(new Conversation()); // send a test conversation
  }
  
  // Recieve data from the client, filtered by the Client class for relevance
  void recieve(data) {
    print("NpcHandler recieved data: $data");
  }
  
  void add(Conversation conv) {
    // (Could also just take in an id and load the conversation from a db)
    print("Sending");
    send({"cmd":"npc","conversation":"Hey there"});
  }
}

class Conversation {
  // Represents a hero/npc conversation (not quite sure how reaching into the heros inv will work)
}