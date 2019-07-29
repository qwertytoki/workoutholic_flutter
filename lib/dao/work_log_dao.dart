import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:workoutholic/dto/work_log.dart';

class WorkLogDao {
  static Stream<QuerySnapshot> getLogByUserId(String userId) {
    return Firestore.instance
        .collection("workLog")
        .where('user_id', isEqualTo: userId)
        .snapshots();
  }
}
