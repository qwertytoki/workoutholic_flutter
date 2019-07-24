// deprecated firebase接続の参考にとっといてるだけ
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutMenu {
  static Stream<QuerySnapshot> getMenuFromWorkoutPlan(List<String> workoutIds) {
    return Firestore.instance
        .collection("workoutMenu")
        .where('workoutId', arrayContains: workoutIds)
        .snapshots();
  }
}
