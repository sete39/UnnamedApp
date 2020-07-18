import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/summoner_info.dart';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:unnamed_app_project/search_page/summoner_info_widget.dart';

class SummonerPage extends StatefulWidget {
  final String region;
  final String summonerName;

  const SummonerPage(this.summonerName, this.region);
  @override
  _SummonerPageState createState() => _SummonerPageState(summonerName, region);
}

class _SummonerPageState extends State<SummonerPage> {
  final String region;
  final String summonerName;
  final _httpClient = HttpClient();
  bool _completedFuture = false;
  SummonerInfo _summonerInfo;
  _SummonerPageState(this.summonerName, this.region);

  Future<int> _readJson(String summonerName, String region) async {
    // final json = DefaultAssetBundle.of(context).loadString(path);
    if (_completedFuture) {
      return 1;
    }
    try {
      print('sending request');
      final uri = Uri.http('10.0.1.42:5000', '/v1/tft',
          {'name': summonerName, 'region': region});
      print(uri);
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      print('got json' + HttpStatus.ok.toString());
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      final jsonBody = json.decode(responseBody);
      final summonerInfoMap = Map<String, dynamic>.from(await jsonBody);
      final summonerInfo = SummonerInfo.fromJson(summonerInfoMap);
      setState(() {
        _summonerInfo = summonerInfo;
        _completedFuture = true;
      });
      return 1;
    } on Exception catch (e) {
      print('$e');
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _summonerFuture = _readJson(summonerName, region);
    final _summonerInfoWidget = SummonerInfoWidget(
        game: null, summonerInfo: _summonerInfo, font: 'Raleway');
    final _futureErrorWidget = Text(
        'Summoner was not found or there was a problem getting the summoner stats.' +
            ' Please make sure the correct region was selected and search again',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Colors.black54,
        ));
    return Container(
        child: FutureBuilder(
      future: _summonerFuture,
      builder: (context, snapshot) {
        Widget _displayedWidget;
        if (snapshot.hasData) {
          if (snapshot.data == 1)
            _displayedWidget = _summonerInfoWidget;
          else if (snapshot.data == -1) _displayedWidget = _futureErrorWidget;
        } else if (snapshot.hasError) {
          _displayedWidget = _futureErrorWidget;
        } else {
          _displayedWidget = SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop()),
            title: Text(
              summonerName,
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(5, 30, 5, 15),
            alignment: Alignment.topCenter,
            child: _displayedWidget,
          ),
        );
      },
    ));
  }
}
