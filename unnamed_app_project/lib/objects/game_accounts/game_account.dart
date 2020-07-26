// GameAccount is the parent of all account classes
abstract class GameAccount {
  String gameName;
  String displayName;
  // rank of the account in the game, empty string ('') if unranked
  String accountRank;
  // level of the account in the game, 0 if the game has no leveling system
  int accountLevel;
  // the id could be anything that identifies the game account
  // what this is depends on the game's API, so could be the account name
  // in the game or an actual id gotten from the game's api
  // the id is what will be sent to the app's proxy api server to handle getting
  // the information from the game's api and send it to the unnamed_app
  // the id must be initialized first and then other variables will be read
  // from the proxy api
  String id;

  GameAccount(this.id) {
    Map jsonMap = getJson();
    readJson(jsonMap);
  }

  Map getJson();
  // abstract class that would initialize the variables above, except id which
  // is initialized with the constructor. Constructor should call this function
  void readJson(Map jsonMap);
}
