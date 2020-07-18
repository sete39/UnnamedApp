import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/summoner_info.dart';
import 'package:unnamed_app_project/search_page/summoner_info_widget.dart';
import 'package:unnamed_app_project/account_view/login_page.dart';
import 'package:unnamed_app_project/search_page/search_page.dart';
import 'dart:convert' show json, utf8, jsonDecode;
import 'dart:io';

class MainPage extends StatefulWidget {
  const MainPage();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _httpClient = HttpClient();
  String _hintText = 'Enter Summoner Name';
  List<String> _serverList = ['EUW', 'EUNE', 'NA'];
  int _selectedIndex = 0;
  String _appBarTitleText = 'Accounts';
  SummonerInfo _summonerInfo;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0)
        _appBarTitleText = 'Accounts';
      else if (_selectedIndex == 1)
        _appBarTitleText = 'League of Legends';
      else if (_selectedIndex == 2) _appBarTitleText = 'Favorites';
    });
  }

  Future<int> _readJson(String path) async {
    // final json = DefaultAssetBundle.of(context).loadString(path);
    print('sending request');
    final uri = Uri.http('10.0.2.2:5000', '/v1/tft',
        {'name': 'HornyModeKurumx', 'region': 'na1'});
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
    });
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final searchColor = Theme.of(context).primaryColor;
    const double width = 346.0;
    const double height = 50.0;
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    const TextStyle searchPageTextStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 1),
      fontFamily: 'Raleway',
    );
    List<Widget> _widgetOptions = <Widget>[
      LoginPage(width: width, height: height),
      SearchPage(
        searchColor,
        width: width,
        height: height,
        textStyle: searchPageTextStyle,
        hintText: _hintText,
        serverList: _serverList,
      ),
      Text('test'),
    ];

    final navBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text(''),
        ),
      ],
      backgroundColor: Colors.black,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      onTap: _onItemTapped,
    );
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text(
          _appBarTitleText,
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: navBar,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
