import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/user.dart';

import 'package:unnamed_app_project/search_page/summoner_page.dart';

class SearchPage extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final double radius;
  final TextStyle textStyle;
  final String hintText;
  final List<String> serverList;
  final User user;
  const SearchPage(this.color,
      {this.width = 346,
      this.height = 50,
      this.radius = 10,
      @required this.user,
      @required this.hintText,
      @required this.serverList,
      @required this.textStyle});

  _SearchPageState createState() => _SearchPageState(
      color, width, height, radius, textStyle, hintText, serverList, user);
}

class _SearchPageState extends State<SearchPage> {
  final Color color;
  final double width;
  final double height;
  final double radius;
  final TextStyle textStyle;
  final String hintText;
  final List<String> serverList;
  final User user;
  _SearchPageState(this.color, this.width, this.height, this.radius,
      this.textStyle, this.hintText, this.serverList, this.user);

  String dropdownValue = 'EUW';

  @override
  Widget build(BuildContext context) {
    final dropdownItems =
        serverList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, style: textStyle),
      );
    }).toList();
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextFormField(
                cursorColor: Colors.white,
                style: textStyle,
                onFieldSubmitted: (String summonerName) {
                  print(user);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SummonerPage(summonerName, dropdownValue, user),
                    ),
                  );
                }, // fix when done with backend
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter Summoner Name',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontFamily: 'Raleway'),
                ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                value: dropdownValue,
                items: dropdownItems,
                dropdownColor: Colors.black,
                focusColor: Colors.black,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                hint: Text(
                  dropdownValue,
                  style: textStyle,
                ),
              ),
            ),
          ],
        ));
  }
}
