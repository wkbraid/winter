// file: conversation.dart
// contains: Conversation

part of common;

class Conversation {
  // Represents a hero/npc conversation (not quite sure how reaching into the heros inv will work)
  int mNum; // number message in the list
  Map conversation;
  NPC npc; // NPC of the conv
  
  // possibly add reset conversation numbers to represent message(s) where the convo will start when the character returns
  
  Conversation(this.npc) {
    mNum = 0;
  }
  
  void addConversation(Map conv){
    conversation = conv;
  }
  
  String retrieveMessage(){
    Map msg = conversation[npc]['message'][mNum];
    if((mNum >= 0)&&(checkConditions(msg)))
      return msg["#text"];
    else return retrieveIntro();
  }
  
  List retrieveChoices(){
    return conversation[npc]['message'][mNum]['choices'];
  }
  
  String retrieveIntro(){
    return conversation['intro'];
  }
  
  bool checkConditions(Map msg){
    if(msg.containsKey("conditions"))
      return true; // default true for now, will eventually check if the conditions for a certain message/option are met
    else return true;
  } 
}