import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  const SearchPage(this.color, {this.width = 346, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: TextFormField(
        cursorColor: color,
        decoration: InputDecoration(
          fillColor: Colors.red,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xFF00000)
            )
          ),
          hintText: 'Enter Summoner Name',
        ),

      )
    );
  }
}