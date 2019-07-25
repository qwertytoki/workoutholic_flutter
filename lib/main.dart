//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/home_page.dart';
import 'package:workoutholic/screen/login_page.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dao/user_dao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User user;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentUser().then((fbUser) {
      _getUser(fbUser).then((userVal) {
        setState(() {
          user = userVal;
        });
      });
    });
  }

  Future<User> _getUser(FirebaseUser fbUser) async {
    return await UserDao.getUserByUid(fbUser.uid);
  }

  Future<FirebaseUser> _getCurrentUser() async {
    return _auth.currentUser();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'login',
        home: Scaffold(
          body: Container(
              child: user == null ? LoginPage() : HomePage(user: user)),
        ));
  }
}
