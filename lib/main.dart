// import 'package:workoutholic/widgets/calendar.dart';
import ''
import 'package:flutter/material.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:'Login Page',
      theme: new ThemeData(
        primarySwatch:Colors.blue,
      ),
      home: new LoginPage()
      // home: new Calendar(),
    );
  }
}
