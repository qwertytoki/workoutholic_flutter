//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/home_page.dart';
import 'package:workoutholic/screen/login_page.dart';

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
              child: _user == null ? LoginPage() : HomePage()),
        ));
  }
}
