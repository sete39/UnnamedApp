import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/summoner_info.dart';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unnamed_app_project/objects/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unnamed_app_project/search_page/summoner_info_widget.dart';

class SummonerPage extends StatefulWidget {
  final String region;
  final String summonerName;
  final User user;
  const SummonerPage(this.summonerName, this.region, this.user);
  @override
  _SummonerPageState createState() =>
      _SummonerPageState(summonerName, region, user);
}

class _SummonerPageState extends State<SummonerPage> {
  final String region;
  final String summonerName;
  final User user;
  final _httpClient = HttpClient();
  final firestore = Firestore.instance;
  bool _completedFuture = false;
  SummonerInfo _summonerInfo;
  _SummonerPageState(this.summonerName, this.region, this.user);

  // sends a requrest to proxy api to get info of the user's tft accouunt
  Future<int> _readJson(String summonerName, String region) async {
    if (_completedFuture) {
      return 1;
    }
    try {
      print('sending request');
      final uri = Uri.http('unnamedappproject-284416.oa.r.appspot.com',
          '/v1/tft', {'name': summonerName, 'region': region, 'matches': '1'});
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

  Future<void> _addToServer() async {
    if (user == null) {
      Fluttertoast.showToast(
        msg:
            'Please login first by going back and clicking the first button on the left',
        backgroundColor: Colors.grey[400],
        textColor: Colors.black87,
      );
      return;
    }
    print('Adding user ' + user.firebaseUser.uid);
    Fluttertoast.showToast(
      msg: 'Adding account',
      backgroundColor: Colors.grey[400],
      textColor: Colors.black87,
    );
    final accountInfoMap = [
      {
        'gameid': summonerName,
        'gameName': 'Teamfight Tactics',
        'region': region,
      }
    ];
    await firestore
        .collection('gameaccounts')
        .document(user.firebaseUser.uid)
        .updateData({'accounts': FieldValue.arrayUnion(accountInfoMap)});
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
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                iconSize: 30,
                onPressed: () {
                  _addToServer();
                },
              ),
            ],
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
