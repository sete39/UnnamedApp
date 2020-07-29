import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnamed_app_project/account_view/game_account_widget.dart';
import 'package:unnamed_app_project/objects/game_accounts/game_account.dart';
import 'package:unnamed_app_project/objects/game_accounts/riot_account.dart';
import 'package:unnamed_app_project/objects/user.dart';

class LoggedInPage extends StatefulWidget {
  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  List<GameAccountWidget> gameAccountWidgets = [];
  bool _completedFuture = false;
  final Firestore firestore = Firestore.instance;

  Future<int> _retrieveAccountsFromFirestore(User user) async {
    if (_completedFuture) return 1;
    try {
      final userAccountsDocument = await firestore
          .collection('gameaccounts')
          .document(user.firebaseUser.uid)
          .get();
      final accountsJsonMap = userAccountsDocument.data;

      // loops through the accounts document of the user and creates
      // a GameAccountWidget for each account. All the accounts are saved in the
      // list gameAccountWidgets
      final List<GameAccount> gameAccounts = <GameAccount>[];
      for (final Map<dynamic, dynamic> account in accountsJsonMap['accounts']) {
        if (account['gameName'] == 'Teamfight Tactics' ||
            account['gameName'] == 'League of Legends') {
          gameAccounts.add(
            RiotAccount(
              account['gameid'],
              account['gameName'],
              account['region'],
            ),
          );
        }
      }

      for (final account in gameAccounts) {
        await account.retrieveInformation();
      }

      setState(() {
        _completedFuture = true;
      });
      print(gameAccounts[0].accountLevel);
      return 1;
    } on Exception catch (e) {
      print('$e');
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of(context);
    //TODO: Use below future in FutureBuilder to keep a
    // CircularProgressIndicator until the future is complete
    final future = _retrieveAccountsFromFirestore(user);
    return Container(child: Text(user.firebaseUser.displayName));
  }
}
