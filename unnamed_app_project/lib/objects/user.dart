import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  FirebaseUser firebaseUser;
  static final FirebaseAuth _authenticator = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  User(this.firebaseUser);

  static Future<User> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final user =
        User((await _authenticator.signInWithCredential(credential)).user);
    print("signed in " + user.firebaseUser.displayName);
    return user;
  }

  static Future<User> checkIfLoggedIn() async {
    final FirebaseUser _tempFirebaseUser = await _authenticator.currentUser();
    if (_tempFirebaseUser != null)
      return User(_tempFirebaseUser);
    else
      return null;
  }

  Future<bool> isLoggedIn() async {
    if (await _authenticator.currentUser() == null)
      return false;
    else
      return true;
  }
}
