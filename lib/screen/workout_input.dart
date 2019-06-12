import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/workout_set.dart';
import 'package:workoutholic/dto/workout_menu.dart';

class WorkoutInputPage extends StatelessWidget {
  @override
  // final WorkoutSet workey key, @required this.workoutSetoutSet;
  // WorkoutInputPage({K}) : super(key: key);
  WorkoutSet _workoutSet;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inout Workout"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text("data");
    // return StreamBuilder<QuerySnapshot>(
    //     stream: WorkoutMenu.getMenuFromWorkoutSet(_workoutSet.workoutIds),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) return LinearProgressIndicator();
    //       return _buildList(context, snapshot.data.documents);
    //     });
  }

  // for firebase
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
