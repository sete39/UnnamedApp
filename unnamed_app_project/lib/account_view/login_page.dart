import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final double width;
  final double height;
  const LoginPage({this.width = 346, this.height = 50});
  @override
  _LoginPageState createState() => _LoginPageState(
        width: width,
        height: height,
      );
}

class _LoginPageState extends State<LoginPage> {
  final double width;
  final double height;
  _LoginPageState({this.width = 346, this.height = 50});
  @override
  Widget build(BuildContext context) {
    final googleSignInButton = RaisedButton.icon(
      icon: Container(
        child: Image.asset("assets/images/google_logo.png"),
      ),
      padding: EdgeInsets.fromLTRB(0, 13, 0, 13),
      color: Colors.white,
      label: Container(
        padding: EdgeInsets.fromLTRB(50, 0, 115, 0),
        child: Text('Sign in with Google',
            style: TextStyle(
              color: Color(0xFF757575),
              fontFamily: "Roboto",
              fontSize: 14,
            )),
      ),
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    final twitterSignInButton = RaisedButton.icon(
      icon: Container(
        child: Image.asset("assets/images/twitter_logo.png"),
      ),
      padding: EdgeInsets.fromLTRB(0, 13, 0, 13),
      color: Color(0xFF00ACEE),
      label: Container(
        padding: EdgeInsets.fromLTRB(50, 0, 115, 0),
        child: Text('Sign in with Twitter',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 14,
            )),
      ),
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            child: googleSignInButton,
          ),
          Padding(padding: EdgeInsets.all(8)),
          Container(
            width: width,
            height: height,
            child: twitterSignInButton,
          ),
        ],
      ),
    );
  }
}
