// file: account.dart
part of common;


class Account extends Sync {
  // Holds basic account information, returned from the server when a login is authenticated
  String user; // Username
  Hero hero; // The Hero associated with this account
  
  Account(this.user,this.hero);
  
  // ==== PACKING ====
  // Might be needed eventually for character selection/creation/deletion
  // Currently only the hero is sent to the client
}