import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();
  @override
  Widget build(BuildContext context) {
    final googleSign = GoogleSignInButton(
      borderRadius: 10.0,
      
    );
    final googleSignIn = RaisedButton.icon(
        icon: Container(
          // width: 500,
          // height: 400,
          child: Image.asset("./assets/google_logo.png"),
          ),
        padding: EdgeInsets.fromLTRB(0, 12, 150, 12),
        color: Colors.white,
        label: Text(
          'Sign in with Google',
          style: TextStyle(color: Color(0xFF757575))
          ),
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          ),
        );
      
    return Container(
      width: 346,
      height: 50,
      child: googleSignIn,
    );
  }
}