import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User with ChangeNotifier {
  FirebaseUser firebaseUser;
  bool signedIn = false;
  final FirebaseAuth authenticator = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User();
  User.createFromLoggedInUser(FirebaseUser firebaseUser) {
    this.firebaseUser = firebaseUser;
    signedIn = true;
  }
  Future<int> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    firebaseUser = (await authenticator.signInWithCredential(credential)).user;
    print("signed in " + firebaseUser.uid);
    if (firebaseUser.metadata.creationTime ==
        firebaseUser.metadata.lastSignInTime) {
      final firestoreInstance = Firestore.instance;
      firestoreInstance
          .collection('gameaccounts')
          .document(firebaseUser.uid)
          .setData({
        'accounts': [],
      });
    }
    signedIn = true;
    notifyListeners();
    return 1;
  }

  Future<int> checkIfLoggedIn() async {
    final FirebaseUser _tempFirebaseUser = await authenticator.currentUser();
    if (_tempFirebaseUser != null) {
      signedIn = true;
      firebaseUser = _tempFirebaseUser;
      notifyListeners();
      return 1;
    } else
      return 0;
  }

  Future<bool> isLoggedIn() async {
    if (await authenticator.currentUser() == null)
      return false;
    else
      return true;
  }

  Future<void> signOut() async {
    await authenticator.signOut();
    signedIn = false;
    notifyListeners();
  }
}
