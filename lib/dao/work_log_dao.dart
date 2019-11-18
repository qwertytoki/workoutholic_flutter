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

  static Future<List<WorkLog>> getLogByUserAndDate(
      String userId, DateTime date) async{
    List<WorkLog> list = new List();
    date = new DateTime(date.year,date.month,date.day);
    QuerySnapshot snapshot  = await Firestore.instance
        .collection("workLog")
        .where('user_id', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: date)
        // .orderBy('date')
        // .startAt([date])
        .getDocuments();
    snapshot.documents.forEach((s){
      list.add(WorkLog.of(s));
    });
    return list;
  }

  static Future<void> insertLogs(List<WorkLog> logs) async {
    logs.forEach((log) {
      Firestore.instance.collection('workLog').add(WorkLog.toMap(log));
    });
  }

  static Future<void> updateLogs(List<WorkLog> logs) async{
    logs.forEach((log){
      Firestore.instance
        .collection('workLog')
        .document(log.documentID)
        .updateData({'logs': log.logs});
    });
  }
}
