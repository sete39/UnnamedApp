import 'package:flutter/material.dart';
import 'package:unnamed_app_project/objects/user.dart';

class LoginPage extends StatefulWidget {
  final double width;
  final double height;
  final Function mainPageUserCallback;
  const LoginPage(
      {this.width = 346, this.height = 50, this.mainPageUserCallback});
  @override
  _LoginPageState createState() => _LoginPageState(
      width: width, height: height, mainPageUserCallback: mainPageUserCallback);
}

class _LoginPageState extends State<LoginPage> {
  final double width;
  final double height;
  final Function mainPageUserCallback;
  bool _loggedIn = false, _buttonPressed = false, _completedFuture = false;
  User user;

  _LoginPageState(
      {this.width = 346,
      this.height = 50,
      @required this.mainPageUserCallback});

  Future<int> _handleSignIn() async {
    if (_completedFuture) return 1;
    final tempUser = await User.handleGoogleSignIn();
    setState(() {
      user = tempUser;
      _completedFuture = true;
      _loggedIn = true;
    });
    return 1;
  }

  Future<bool> _checkIfLoggedIn() async {
    if (_completedFuture || _loggedIn) return true;
    final tempUser = await User.checkIfLoggedIn();
    if (tempUser != null) {
      setState(() {
        user = tempUser;
        _completedFuture = true;
        _loggedIn = true;
        mainPageUserCallback(user);
      });
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    Future checkingLogin = _checkIfLoggedIn();
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
      onPressed: () {
        setState(() {
          _buttonPressed = true;
        });
      },
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

    final _notLoggedInWidget = Center(
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

    if (_buttonPressed) {
      final futureBuilder = FutureBuilder(
        future: _handleSignIn(),
        builder: (context, snapshot) {
          Widget _displayedWidget;
          if (snapshot.hasData) {
            print(user.firebaseUser);
            mainPageUserCallback(user);
            _displayedWidget =
                Text("You are logged in to " + user.firebaseUser.displayName);
            return _displayedWidget;
          }
          _displayedWidget = SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );

          return _displayedWidget;
        },
      );
      return futureBuilder;
    } else {
      if (_loggedIn)
        return Text("You are logged in as " + user.firebaseUser.displayName);
      return _notLoggedInWidget;
    }
  }
}
