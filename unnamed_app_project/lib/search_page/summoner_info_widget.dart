import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/summoner_info.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SummonerInfoWidget extends StatelessWidget {
  final SummonerInfo summonerInfo;
  final String game; // must be either 'TFT' or 'LoL'
  final String font;
  const SummonerInfoWidget(
      {@required this.game,
      @required this.summonerInfo,
      this.font = 'Raleway'});
  @override
  Widget build(BuildContext context) {
    String _winRate = summonerInfo.past20top1WR.toStringAsFixed(1);
    String _top4winRate = summonerInfo.past20top4WR.toStringAsFixed(1);
    Color _wrColor, _top4wrColor;
    summonerInfo.past20top1WR > 12.5
        ? _wrColor = Colors.green[600]
        : _wrColor = Colors.red[600];
    summonerInfo.past20top4WR > 50
        ? _top4wrColor = Colors.green[600]
        : _top4wrColor = Colors.red[600];
    if (summonerInfo.isRanked)
      final totalGames =
          summonerInfo.summonerRankLosses[0] + summonerInfo.summonerRankWins[0];
    else
      final totalGames = 0;

    TextStyle playerMainTextStyle =
        TextStyle(fontFamily: font, color: Colors.white, fontSize: 14);
    final Column _playerTextInfo = Column(children: [
      Row(
        children: [
          Container(
            width: 129,
            child: AutoSizeText(
              summonerInfo.summonerName,
              style: playerMainTextStyle,
              maxLines: 1,
              minFontSize: 13,
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
          Container(
            width: 82,
            child: AutoSizeText(
              summonerInfo.isRanked
                  ? summonerInfo.summonerRankInfo[0]
                  : 'Level ' + summonerInfo.summonerLevel.toString(),
              style: playerMainTextStyle,
              maxLines: 1,
              minFontSize: 13,
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0))
        ],
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      ),
      Container(
          alignment: Alignment.centerLeft,
          width: 221,
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: RichText(
              text: TextSpan(
                  text: 'Top 1 WR: ',
                  style: playerMainTextStyle,
                  children: <TextSpan>[
                TextSpan(
                  text: '$_winRate%',
                  style: TextStyle(
                      fontFamily: font,
                      color: _wrColor,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' (20 Games)',
                  style: playerMainTextStyle,
                ),
              ]))),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      ),
      Container(
          alignment: Alignment.centerLeft,
          width: 221,
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: RichText(
              text: TextSpan(
                  text: 'Top 4 WR: ',
                  style: playerMainTextStyle,
                  children: <TextSpan>[
                TextSpan(
                  text: '$_top4winRate%',
                  style: TextStyle(
                      fontFamily: font,
                      color: _top4wrColor,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' (20 Games)',
                  style: playerMainTextStyle,
                ),
              ])))
    ]);
    print(summonerInfo.profileIconURL);
    final _playerInfo = ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
        child: Row(
          children: [
            Image.network(
              summonerInfo.profileIconURL,
              height: 115,
              width: 115,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            ),
            _playerTextInfo,
          ],
        ));
    final _rankedInfo = summonerInfo.isRanked
        ? Container(
            height: 121,
            width: 325,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFF121212),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  child: Text(
                    'Ranked',
                    textAlign: TextAlign.left,
                    style: playerMainTextStyle,
                  ),
                  padding: EdgeInsets.fromLTRB(13, 18, 5, 0),
                ),
                Container(
                  child: Text(
                    summonerInfo.summonerRankInfo[0] +
                        ' ' +
                        summonerInfo.summonerRankLP[0].toString() +
                        ' LP',
                    textAlign: TextAlign.left,
                    style: playerMainTextStyle,
                  ),
                  padding: EdgeInsets.fromLTRB(10, 18, 13, 0),
                ),
              ])
            ]))
        : Container();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      height: 275,
      width: 346,
      child: Column(
        children: [
          _playerInfo,
          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          _rankedInfo,
        ],
      ),
    );
  }
}
