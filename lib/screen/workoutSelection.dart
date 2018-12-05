import 'package:flutter/material.dart';

class WorkoutSelection extends StatelessWidget {
  @override

  final DateTime selectedDate;
  WorkoutSelection({Key key, @required this.selectedDate}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Menu"),
      ),
      body: 
        Column(
          children:<Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
            Text(selectedDate.toString()),
          ] 
        ),
    );
  }
}