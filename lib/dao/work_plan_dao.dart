import 'package:workoutholic/dto/work_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class WorkPlanDao {
  static Stream<QuerySnapshot> getPlansStream(String userId) {
    return Firestore.instance
        .collection('workPlan')
        .where('user_id', isEqualTo: userId)
        .snapshots();
  }

  static Future<WorkPlan> getPlanByCode(String planCode, String userId) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('workPlan')
        .where('user_id', isEqualTo: userId)
        .where('planCode', isEqualTo: planCode)
        .getDocuments();
    WorkPlan plan;
    snapshot.documents.forEach((s) {
      plan = WorkPlan.of(s);
    });
    return plan;
  }

  static Future<List<WorkPlan>> getPlans(String userId) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('workPlan')
        .where('user_id', isEqualTo: userId)
        .getDocuments();
    List<WorkPlan> plans = new List();
    snapshot.documents.forEach((s) {
      plans.add(WorkPlan.of(s));
    });
    return plans;
  }

  static Future<void> insertPlan(WorkPlan plan) async {
    Firestore.instance
      .collection("workPlan")
      .add(WorkPlan.toMap(plan));
  }
}
