import 'package:meta/meta.dart';

// should (so far at least) work with both TFT and League
class SummonerInfo {
  final String summonerName;
  final String profileIconURL;
  final int summonerLevel;
  final double past20top1WR;
  final double past20top4WR;
  final bool isRanked;
  // if summoner stats are for tft, then size of the lists are always 1 or 0 and
  // are only for the ranked tft stats
  // if summoner stats are for LoL, then size of the lists are 0 - 2 for either
  // ranked solo/duo or ranked flex
  final List<dynamic> summonerRankInfo;
  final List<dynamic> summonerRankType;
  final List<dynamic> summonerRankLP;
  final List<dynamic> summonerRankLosses;
  final List<dynamic> summonerRankedWinRate;
  final List<dynamic> summonerRankWins;

  const SummonerInfo(
      {@required this.summonerName,
      this.profileIconURL,
      this.summonerLevel,
      this.summonerRankInfo,
      this.summonerRankType,
      this.summonerRankLP,
      this.summonerRankLosses,
      this.summonerRankedWinRate,
      this.summonerRankWins,
      this.past20top1WR,
      this.past20top4WR,
      this.isRanked});

  SummonerInfo.fromJson(Map jsonMap)
      : summonerName = jsonMap['summonerInfo']['name'],
        profileIconURL = jsonMap['summonerInfo']['profileIconURL'],
        summonerLevel = jsonMap['summonerInfo']['summonerLevel'],
        summonerRankInfo = jsonMap['summonerInfo']['rankedInfo'],
        summonerRankType = jsonMap['summonerInfo']['rankedType'],
        summonerRankLP = jsonMap['summonerInfo']['rankedLP'],
        summonerRankLosses = jsonMap['summonerInfo']['rankedLosses'],
        summonerRankedWinRate = jsonMap['summonerInfo']['rankedWinRate'],
        summonerRankWins = jsonMap['summonerInfo']['rankedWins'],
        past20top1WR = jsonMap['summonerInfo']['top1WR'],
        past20top4WR = jsonMap['summonerInfo']['top4WR'],
        isRanked = jsonMap['summonerInfo']['isRanked'];
}
