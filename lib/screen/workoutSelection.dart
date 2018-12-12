import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutSelection extends StatelessWidget {
  @override

  final DateTime selectedDate;
  WorkoutSelection({Key key, @required this.selectedDate}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Workout"),
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