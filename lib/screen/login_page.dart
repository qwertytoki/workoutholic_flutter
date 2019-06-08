import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/home_page.dart';

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
  final _googleSignIn = new GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  FirebaseUser user = await _auth.signInWithCredential(
      GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken));
  print("signed in " + user.displayName);
  if (user != null) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return HomePage();
      },
    ));
  }
}

enum FormType { login, register }
