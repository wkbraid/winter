// file: gui.dart
// contains: Gui

part of client;

class Gui {
  
  ChatHandler chat; // Handles user chat
  Stage stage; // The stage part of the gui
  
  //Overlay types
  static const NO_OVERLAY = 0;
  static const INVENTORY_OVERLAY = 1;
  static const STATS_OVERLAY = 2;
  static const BANK_OVERLAY = 3;
  static const NPC_CHAT_OVERLAY = 4;
  static const MAP_OVERLAY = 5;
  static const SPELLS_OVERLAY = 6;
  // Number that determines what overlay is covering the main game screen (if any).
  int overlayStatus;
  
  var send; // Send function taken from game
  
  Gui(this.send) {
    chat = new ChatHandler("chatInput","chatOutput",send);
    overlayStatus = 0;
  }
  
  //Handles the graphical user interface
  void login(callback) {
    querySelector("#logMeIn").onClick.listen((e) {
      InputElement tf = querySelector("#textfield");
      callback(tf.value);
    });
  }
  
  void update(int dt) {
    if (Keyboard.isDown(KeyCode.ESC)) {
      overlayStatus = NO_OVERLAY; // escape from current overlay
      drawOverlay();
      print("overlay closed");
    }
  }
  
  void draw() {
    drawInv(); // Draw the inventory
    drawSpells();; // Draw spells
    drawBars(); // Draw the health and mana bars (possibly other stats later)
    drawStats(); // Draw the stats
  }
  
  void receive(data) { // receive data sent from the server
    if (data["cmd"] == "npc") {
      print("Gui received npc message: ${data["message"]}");
      print("NPC chat overlay open, hit escape to re-enable keyboard controls");
      // Open an overlay here
      overlayStatus = NPC_CHAT_OVERLAY;
      querySelector(".npc").text = data["message"];
      drawOverlay();
    }
  }
  
  void listen(){
    // inv button
    querySelector(".nav tr td:nth-child(1)").onClick.listen(
        (e) { overlayStatus = toggleOverlay(INVENTORY_OVERLAY, overlayStatus);
              drawOverlay();
    });
    // stats button
    querySelector(".nav tr td:nth-child(2)").onClick.listen(
        (e) { overlayStatus = toggleOverlay(STATS_OVERLAY, overlayStatus);
              drawOverlay();
         });
    // spells button
    querySelector(".nav tr td:nth-child(3)").onClick.listen(
        (e) { overlayStatus = toggleOverlay(SPELLS_OVERLAY, overlayStatus);
              drawOverlay();
         });
    querySelector(".npc").onClick.listen(
        (e) { overlayStatus = NO_OVERLAY;
              drawOverlay();
        });
    querySelector("#area").onClick.listen(
        (e) {
          // add the server-gui stuff
        });
  }
  
  // If the requested overlay is already assigned to hero, assign NO_OVERLAY
  int toggleOverlay(int requested, int old){
    if(old == requested)
      return NO_OVERLAY;
    else
      return requested;
  }
  
  void drawOverlay(){
    DivElement window = querySelector(".window");
    DivElement equipment = querySelector(".equipment");
    DivElement backpack = querySelector(".backpack");
    DivElement stats = querySelector(".stats");

    TableElement spells = querySelector(".all_spells");
    DivElement npc = querySelector(".npc");

    switch(overlayStatus){
      case NO_OVERLAY: 
        hide(window);
        emptyWindow([equipment, backpack, stats, spells, npc]);
        return;
      case INVENTORY_OVERLAY: 
        emptyWindow([stats, spells, npc]);
        fillWindow([equipment, backpack]);
        show(window);
        return;
      case STATS_OVERLAY: 
        emptyWindow([equipment, backpack, spells, npc]);
        fillWindow([stats]);
        show(window);
        return;
      case BANK_OVERLAY: 
        emptyWindow([equipment, backpack, stats, spells, npc]);
        show(window);
        return;
      case NPC_CHAT_OVERLAY: // may not use window
        hide(window);
        emptyWindow([equipment, backpack, stats, spells]);
        fillWindow([npc]); // need a delay or needs to use window
        return;
      case MAP_OVERLAY: 
        emptyWindow([equipment, backpack, stats, spells, npc]);
        show(window);
        return;
      case SPELLS_OVERLAY:
        emptyWindow([equipment, backpack, stats, npc]);
        fillWindow([spells]);
        show(window);
        return;
      default: break;
    }
  }
  
  void emptyWindow(List<Element> divs){
    for(Element div in divs)
      div.classes.add("hide");
  }
  
  void fillWindow(List<Element> divs){
    for(Element div in divs)
      div.classes.remove("hide");
  }
  
  void toggleVisible(DivElement div){ // probably will remove later
    if (div.style.left == "900px")
      div.style.left = "-5px";
    else div.style.left = "900px";
  }
  
  void show(DivElement div){ 
    div.style.left = "-5px";
  }
  
  void hide(DivElement div){
    div.style.left = "900px";
  }
  
  void drawInv(){
    // draw the hero's items in the gui
    int i = 1;
    querySelector(".backpack").children=[];
    querySelector(".equipment").children=[]; // REWRITING, will be changed to UPDATING
    for (Item key in stage.hero.inv.backpack.keys) {
      int count = stage.hero.inv.backpack[key];
      if(i <= 7){ // go in the hotbar
      TableCellElement obj = querySelector(".items td:nth-child("+i.toString()+")");
      obj.classes.remove("empty");
      obj.style.background = key.color;
      obj.style.border = "1px solid black";
      obj.text = count.toString();
      }
      if (i > 7){ // go in the backpack
        DivElement obj = new DivElement();
        obj.classes.add("bp_obj");
        obj.style.background = key.color;
        obj.text = count.toString();
        querySelector(".backpack").children.add(obj);
      }
      i++;
    }
    for(Equipable eq in stage.hero.inv.equipment){ // draws equipment
      if(eq != null){
        DivElement obj = new DivElement();
        obj.classes.add("bp_obj");
        obj.style.background = eq.color;
        querySelector(".equipment").children.add(obj);
      }
    }
  }
  
void drawSpells(){
    TableElement spells = querySelector(".all_spells");
    TableRowElement temp = querySelector(".TEMP");
    spells.children = [temp]; // REWRITING, will be changed to UPDATING
    int i = 1;
    for (String spell in stage.hero.spells.keys){
      if(i <= 7){
        TableCellElement obj = querySelector(".spells td:nth-child("+i.toString()+")");
        obj.classes.remove("empty");
        obj.style.background = stage.hero.spells[spell].color;
        obj.text = spell;
        obj.style.border = "1px solid black";
      }
      TableRowElement sp = new TableRowElement();
      sp.insertCell(0).text = spell;
      sp.insertCell(1).text = "This does something, probably";
      sp.insertCell(2).text = stage.hero.spells[spell].mana.toString();
      sp.insertCell(3).text = stage.hero.spells[spell].cooldown.toString();
      spells.children.add(sp);
      i++;
    }
  }
  
  void drawStats(){
    querySelector(".stats").text = stage.hero.name + " Speed: " + stage.hero.stats.speed.toString()
                                   + " Jump: " + stage.hero.stats.jump.toString();
 }
  
  drawQuests(){
    
  }
  
  void drawBars(){
    // draw the hero's stats in the gui
    querySelector(".bar:nth-child(1)").style.width = stage.hero.stats.hpmax.toString() + "px"; // set healthbar border to max hp
    querySelector(".bar:nth-child(2)").style.width = stage.hero.stats.mpmax.toString() + "px"; //set manabar holder to max mp
    querySelector(".health").style.width = stage.hero.hp.toString() + "px"; // set healthbar to hp
    querySelector(".health").text = stage.hero.hp.toString(); // print health
    querySelector(".mana").style.width = stage.hero.mp.toString() + "px"; // set manabar to mp, takes a little to catch up with game logic
    querySelector(".mana").text = stage.hero.mp.toInt().toString(); // print mana
 }
}