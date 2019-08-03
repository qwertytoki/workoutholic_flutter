import 'package:workoutholic/dto/work_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkPlanDao {
  static Stream<QuerySnapshot> getPlansByUser(String userId) {
    return  Firestore.instance
    .collection('workPlan')
    .where('user_id',isEqualTo: userId)
    .snapshots();
  }
}
