import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/const/work_type.dart';

class WorkLog {
  WorkLog({
    this.id = '',
    this.userCode = '',
    this.menuCode = '',
    this.reps = const [],
    this.weights = const [],
    this.date,
    this.workType = WorkType.LIFT,
  });

  String id;
  String userCode;
  String menuCode;
  List<int> reps;
  List<int> weights;
  Timestamp date;
  WorkType workType;

  static WorkLog of(DocumentSnapshot document) {
    if (!document.exists) {
      return new WorkLog();
    }
    return new WorkLog(
      id: document.documentID,
      userCode: document['user_code'],
      menuCode: document['menu_code'],
      reps: document['reps'],
      weights: document['weights'],
      date: document['date'] ?? '',
      workType: document['work_type'],
    );
  }

  bool isEmpty() {
    return this.id == '';
  }

  // Delete me after using firebase
  static WorkLog createNewLog(String id, String userCode, String menuCode,
      List<int> reps, List<int> weights, Timestamp date, WorkType workType) {
    return new WorkLog(
      id: id,
      userCode: userCode,
      menuCode: menuCode,
      reps: reps,
      weights: weights,
      date: date,
      workType: workType,
    );
  }
}
