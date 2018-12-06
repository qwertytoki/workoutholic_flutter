import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutSet {
  static const String WORKOUT_MENU = "workoutSet";

  static Stream<QuerySnapshot> getAllWorkouts() {
    return Firestore.instance
        .collection(WORKOUT_MENU)
        .orderBy('workoutName', descending: true)
        .snapshots();
  }
}