import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/summoner_info.dart';

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
    TextStyle playerMainTextStyle =
        TextStyle(fontFamily: font, color: Colors.white, fontSize: 16);
    final Column _playerTextInfo = Column(children: [
      FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            Text(
              summonerInfo.summonerName,
              style: playerMainTextStyle,
            ),
            Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
            Text(
              summonerInfo.summonerRankInfo[0],
              style: playerMainTextStyle,
            ),
          ],
        ),
      )
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
    final Row _rankedInfo = Row(children: []);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      height: 275,
      width: 346,
      child: Column(
        children: [_playerInfo],
      ),
    );
  }
}
