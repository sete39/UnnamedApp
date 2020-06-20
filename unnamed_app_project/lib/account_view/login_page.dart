import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();
  @override
  Widget build(BuildContext context) {
    final googleSignInButton = RaisedButton.icon(
      icon: Container(
        // width: 500,
        // height: 400,
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
            width: 346,
            height: 50,
            child: googleSignInButton,
          ),
          Padding(padding: EdgeInsets.all(8)),
          Container(
            width: 346,
            height: 50,
            child: twitterSignInButton,
          ),
        ],
      ),
    );
  }
}
