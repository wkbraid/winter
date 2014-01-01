// file: account.dart
// contains: Account

part of common;


class Account {
  // Holds basic account information, returned from the server when a login is authenticated
  String user; // Username
  Hero hero; // The Hero associated with this account
  
  Account(this.user,this.hero);
  
  // ==== PACKING ====
  // Might be needed eventually for character selection/creation/deletion
  // Currently only the hero is sent to the client
}