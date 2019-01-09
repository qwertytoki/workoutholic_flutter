import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class WorkoutSet {
//   static const String WORKOUT_MENU = "workoutSet";

//   static Stream<QuerySnapshot> getAllWorkouts() {
//     return Firestore.instance
//         .collection(WORKOUT_MENU)
//         .orderBy('workoutName', descending: true)
//         .snapshots();
//   }
// }
class WorkoutSet {
  final String setName;
  final List<String> workoutIds;
  final DocumentReference reference;

  WorkoutSet.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['setName'] != null),
        assert(map['workoutIds'] != null),
        setName = map['setName'],
        workoutIds = map['workoutIds'].cast<String>();

  WorkoutSet.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "WorkoutSet<$setName>";
}