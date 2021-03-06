import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/home_page.dart';
import 'package:workoutholic/dao/user_dao.dart';
import 'package:workoutholic/dto/user.dart';

class LoginPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(child: _buildGoogleSignInButton(context)));
  }
}

Widget _buildGoogleSignInButton(BuildContext context) {
  return Scaffold(
      body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
          child: RaisedButton(
        child: Text("Google Sign In"),
        onPressed: () {
          _handleGoogleSignIn(context);
        },
      )),
    ],
  ));
}

void _handleGoogleSignIn(BuildContext context) async {
  Locale locale = Localizations.localeOf(context);
  String language = locale.languageCode == "ja" ? "ja" : "en";
  try {
    final _googleSignIn = new GoogleSignIn();
    final _auth = FirebaseAuth.instance;
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser fbUser = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken));
    User user = await UserDao.getUserByUid(fbUser.uid);
    if (user.uid=="") {
      user =new User(
        uid:fbUser.uid,
        displayName:fbUser.displayName,
        photoUrlMobile: fbUser.photoUrl,
        description: language == 'ja'?"目標を記入しよう！":"Set your goal!",
        language: language);
      await UserDao.addUser(user);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return HomePage(user: user);
      },
    ));
  } catch (e) {
    String message = language == 'ja' ? 'ログインに失敗しました' : 'Failed to login.';
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
    ));
    return;
  }
}
