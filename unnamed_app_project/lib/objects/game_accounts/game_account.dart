import 'dart:convert' show json, utf8;
import 'dart:io';

// GameAccount is the parent of all account classes
abstract class GameAccount {
  String profilePhotoURL;
  String displayName;
  // rank of the account in the game, empty string ('') if unranked
  // if the game has multiple ranks for one player, the highest rank of them
  // is chosen
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
  final String id;
  final String gameName;
  final _httpClient = HttpClient();

  // this constructor used for testing
  GameAccount.testConstructor(this.profilePhotoURL, this.displayName,
      this.accountRank, this.accountLevel, this.id, this.gameName);

  GameAccount(this.id, this.gameName);

  Future<int> retrieveInformation() async {
    final Uri uri = getUri();
    Map jsonMap = await getJson(uri);
    if (jsonMap == null) {
      // if the map returned was null then there was a problem retrieving info
      // from firebase
      return -1;
    }
    readJson(jsonMap);
    return 1;
  }

  Future<Map> getJson(Uri uri) async {
    try {
      print('sending request');
      print(uri);
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      print('got json' + HttpStatus.ok.toString());
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      final jsonBody = json.decode(responseBody);
      final jsonMap = Map<String, dynamic>.from(await jsonBody);
      return jsonMap;
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  Uri getUri();

  // abstract class that would initialize the variables above, except id which
  // is initialized with the constructor. Constructor should call this function
  void readJson(Map jsonMap);
}
