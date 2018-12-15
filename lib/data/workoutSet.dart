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
  // final int votes;
  final DocumentReference reference;

  WorkoutSet.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['setName'] != null),
        // assert(map['votes'] != null),
        setName = map['setName'];
        // votes = map['votes'];

  WorkoutSet.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "WorkoutSet<$setName>";
}