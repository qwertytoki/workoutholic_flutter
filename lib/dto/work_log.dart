import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/const/work_type.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/workout_set.dart';

class WorkLog implements ListForSetSelect {
  WorkLog(
      {this.documentID = '',
      this.userId = '',
      this.menuCode = '',
      this.date,
      this.workType = WorkType.LIFT,
      this.logs = const []});

  String documentID;
  String userId;
  String menuCode;
  Timestamp date;
  WorkType workType;
  List<Map<String, Object>> logs;

  static WorkLog of(DocumentSnapshot document) {
    if (!document.exists) {
      return new WorkLog();
    }
    return new WorkLog(
      documentID: document.documentID,
      userId: document['user_id'],
      menuCode: document['menu_code'],
      date: document['date'] ?? '',
      workType: document['work_type'],
      logs: new List<Map<String, double>>.from(document['logs']),
    );
  }

  bool isEmpty() {
    return this.documentID == '';
  }

  static Map<String, dynamic> toMap(WorkLog log) {
    Map<String, Object> data = new Map();
    data.putIfAbsent('user_id', () => log.userId);
    data.putIfAbsent('date', () => log.date);
    data.putIfAbsent('logs', () => log.logs);
    data.putIfAbsent('work_type', () => log.workType.value);
    data.putIfAbsent('menu_code', () => log.menuCode);
    return data;
  }

  // Delete me after using firebase
  static WorkLog createNewLog(String userId, String menuCode,
      List<WorkoutSet> workoutSets, Timestamp date, WorkType workType) {
    List<Map<String, double>> logs = new List();
    workoutSets.forEach((data) {
      logs.add({
        "reps": data.reps.toDouble(),
        "weight": data.weight,
        "unit": data.weightUnit.toDouble()
      });
    });
    return new WorkLog(
      userId: userId,
      menuCode: menuCode,
      logs: logs,
      date: date,
      workType: workType,
    );
  }
}
