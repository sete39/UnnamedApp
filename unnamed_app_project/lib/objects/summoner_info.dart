import 'package:meta/meta.dart';

// should (so far at least) work with both TFT and League
class SummonerInfo {
  final String summonerName;
  final String profileIconURL;
  final int summonerLevel;
  final List<dynamic> summonerRankInfo;
  final List<dynamic> summonerRankType;
  final List<dynamic> summonerRankLP;

  const SummonerInfo(
      {@required this.summonerName,
      this.profileIconURL,
      this.summonerLevel,
      this.summonerRankInfo,
      this.summonerRankType,
      this.summonerRankLP});

  SummonerInfo.fromJson(Map jsonMap)
      : summonerName = jsonMap['summonerInfo']['name'],
        profileIconURL = jsonMap['summonerInfo']['profileIconURL'],
        summonerLevel = jsonMap['summonerInfo']['summonerLevel'],
        summonerRankInfo = jsonMap['summonerInfo']['rankedInfo'],
        summonerRankType = jsonMap['summonerInfo']['rankedType'],
        summonerRankLP = jsonMap['summonerInfo']['summonerRankLP'];
}
