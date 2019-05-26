//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(new MyApp());
  //これ何してるんだろう
  // initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseUser _user;
  final _googleSignIn = new GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<FirebaseUser> _getCurrentUser() async {
    return _auth.currentUser();
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'login',
        home: Scaffold(
          body: Container(
            // ここをログインページにしてあげる必要がありそう
              child: _user == null ? _buildGoogleSignInButton() : HomePage()),
        ));
  }

  Widget _buildGoogleSignInButton() {
    return Scaffold(
      
      appBar: AppBar(
        title: new Text('Welcome'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Center(
            child: RaisedButton(
          child: Text("Google Sign In"),
          onPressed: () {
            _handleGoogleSignIn().then((user) {
              setState(() {
                _user = user;
              });
            }).catchError((error) {
              print(error);
            });
          },
        )),
      ],
      )
      
    );
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken));
    print("signed in " + user.displayName);
    return user;
  }
}
