import 'package:unnamed_app_project/objects/game_accounts/game_account.dart';

class RiotAccount extends GameAccount {
  final String region;
  RiotAccount(String id, String gameName, this.region) : super(id, gameName);

  @override
  Uri getUri() {
    String gameAcronym = 'lol';
    if (gameName == 'Teamfight Tactics') gameAcronym = 'tft';
    final uri = Uri.http(
      'unnamedappproject-284416.oa.r.appspot.com',
      '/v1/$gameAcronym',
      {'name': id, 'region': region, 'matches': '0'},
    );
    return uri;
  }

  @override
  void readJson(Map jsonMap) {
    if (jsonMap['summonerInfo']['rankedInfo'].isNotEmpty)
      accountRank = jsonMap['summonerInfo']['rankedInfo'][0];
    else
      accountRank = '';
    accountLevel = jsonMap['summonerInfo']['summonerLevel'];
    displayName = jsonMap['summonerInfo']['name'];
    profilePhotoURL = jsonMap['summonerInfo']['profileIconURL'];
  }
}
