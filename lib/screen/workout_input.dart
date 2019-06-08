import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/data/workout_set.dart';
import 'package:workoutholic/data/workout_menu.dart';

class WorkoutInputPage extends StatelessWidget {
  @override
  final WorkoutSet workoutSet;
  WorkoutInputPage({Key key, @required this.workoutSet}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Workout"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: WorkoutMenu.getMenuFromWorkoutSet(workoutSet.workoutIds),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final workoutSet = WorkoutSet.fromSnapshot(data);
    return Padding(
      key: ValueKey(workoutSet.setName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(workoutSet.setName),
          // trailing: Text(record.votes.toString()),
          // onTap: () => Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => WorkoutMenuSelect(workoutSet:workoutSet)),
          // ),
        ),
      ),
    );
  }
}