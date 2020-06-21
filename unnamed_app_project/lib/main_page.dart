import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unnamed_app_project/account_view/login_page.dart';
import 'package:unnamed_app_project/search_page/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String _appBarTitleText = 'Accounts';
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0)
        _appBarTitleText = 'Accounts';
      else if (_selectedIndex == 1)
        _appBarTitleText = 'League of Legends';
      else if (_selectedIndex == 2)
        _appBarTitleText = 'Favorites';
    });
  }

  @override
  Widget build(BuildContext context) {
    const searchColor = Colors.black;
    const double width = 346.0;
    const double height = 50.0;
    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    const List<Widget> _widgetOptions = <Widget>[
      LoginPage(width: width, height: height),
      SearchPage(searchColor, width: width, height: height),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
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
          style: TextStyle(
            fontFamily: 'Raleway'
          ),
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