// deprecated firebase接続の参考にとっといてるだけ
import 'package:cloud_firestore/cloud_firestore.dart';

// class WorkoutPlan {
//   static const String WORKOUT_MENU = "workoutPlan";

//   static Stream<QuerySnapshot> getAllWorkouts() {
//     return Firestore.instance
//         .collection(WORKOUT_MENU)
//         .orderBy('workoutName', descending: true)
//         .snapshots();
//   }
// }
class WorkoutPlan {
  final String setName;
  final List<String> workoutIds;
  final DocumentReference reference;

  WorkoutPlan.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['setName'] != null),
        assert(map['workoutIds'] != null),
        setName = map['setName'],
        workoutIds = map['workoutIds'].cast<String>();

  WorkoutPlan.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "WorkoutPlan<$setName>";
}