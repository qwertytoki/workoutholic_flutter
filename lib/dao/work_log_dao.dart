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

  // 同期処理
  static List<WorkLog> getLogByUserAndDate(String userId, DateTime date) {
    List<WorkLog> list = [];
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection("workLog")
        .where('user_id', isEqualTo: userId)
        .orderBy('date')
        .startAt([date]).snapshots();
    snapshots.forEach((snapshot) {
      list.add(WorkLog.of(snapshot.documents[0]));
      return list;
    });

    // return Firestore.instance
    //     .collection("workLog")
    //     .where('user_id', isEqualTo: userId)
    //     .where('date',isEqualTo: date)
    //     .snapshots();
  }

// DocumentSnapshot snapshot = await Firestore.instance
//         .collection(COLLECTION_WISHES)
//         .document(wishID)
//         .get();

  // Use async because I want to update calendar immediately.
  static Future<void> insertLogs(List<WorkLog> logs) async {
    logs.forEach((log) {
      Firestore.instance.collection('workLog').add(WorkLog.toMap(log));
    });
  }
}
