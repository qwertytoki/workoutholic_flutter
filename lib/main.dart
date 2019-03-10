// import 'package:workoutholic/widgets/calendar.dart';
import 'package:workoutholic/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:'Login Page',
      theme: new ThemeData(
        primarySwatch:Colors.blue,
      ),
      home: new LoginPage(auth: new Auth())
      // home: new Calendar(),
    );
  }
}
