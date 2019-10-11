import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_log.dart';

class WorkLogDao {
  static Stream<QuerySnapshot> getLogByUserId(String userId) {
    return Firestore.instance
        .collection("workLog")
        .where('user_id', isEqualTo: userId)
        .snapshots();
  }

  static Stream<QuerySnapshot> getLogByUserAndDate(String userId,DateTime date){
    return Firestore.instance
        .collection("workLog")
        .where('user_id', isEqualTo: userId)
        .where('date',isEqualTo: date)
        .snapshots();
  }

  // Use async because I want to update calendar immediately.
  static Future<void> insertLogs(List<WorkLog> logs) async {
    logs.forEach((log) {
      Firestore.instance
      .collection('workLog')
      .add(WorkLog.toMap(log));
    });
  }
}
