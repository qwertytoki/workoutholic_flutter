import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/latest_work_log.dart';

class LatestWorkLogDao {
  static Future<List<LatestWorkLog>> getLogByUserAndDate(
      String userId, DateTime date) async {
    List<LatestWorkLog> list = new List();
    date = new DateTime(date.year, date.month, date.day);
    QuerySnapshot snapshot = await Firestore.instance
        .collection("latestWorkLog")
        .where('user_id', isEqualTo: userId)
        .where('date', isEqualTo: date)
        .getDocuments();
    snapshot.documents.forEach((s) {
      list.add(LatestWorkLog.of(s));
    });
    return list;
  }
  static Future<List<LatestWorkLog>> getLogByCodes(List<String> menuCodeList)async{
    QuerySnapshot snapshot = await Firestore.instance
      .collection("latestWorkLog")
      .where('menu_code',arrayContains: menuCodeList)
      .getDocuments();
    List<LatestWorkLog> list = new List();
    snapshot.documents.forEach((s){
      list.add(LatestWorkLog.of(s));
    });
    return list;
  }

  static Future<void> insertLogs(List<LatestWorkLog> logs) async {
    logs.forEach((log) {
      Firestore.instance
          .collection('latestWorkLog')
          .add(LatestWorkLog.toMap(log));
    });
  }

  static Future<void> updateLogs(List<LatestWorkLog> logs) async {
    logs.forEach((log) {
      Firestore.instance
          .collection('latestWorkLog')
          .document(log.documentID)
          .updateData({'logs': log.logs});
    });
  }

  static Future<void> deleteLogs(List<LatestWorkLog> logs) async {
    logs.forEach((log) {
      Firestore.instance
          .collection("latestWorkLog")
          .document(log.documentID)
          .delete();
    });
  }
}
