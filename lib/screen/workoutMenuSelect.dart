import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/data/workoutSet.dart';

class WorkoutMenuSelect extends StatelessWidget{
  @override
  final WorkoutSet workoutSet;
  WorkoutMenuSelect({Key key, @required this.workoutSet}) :super(key:key);
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Workout"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    
  }
}