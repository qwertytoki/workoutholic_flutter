import 'package:flutter/material.dart';
import 'screen/login_page.dart';
import 'auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
    State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage>{
  @override
  Widget build(BuildContext context){
    return new LoginPage(auth:widget.auth);
  }
}