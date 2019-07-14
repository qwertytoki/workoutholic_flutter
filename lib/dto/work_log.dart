import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/const/work_type.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/workout_row_data.dart';

class WorkLog implements ListForSetSelect {
  WorkLog({
    this.id = '',
    this.userId = '',
    this.menuCode = '',
    this.date,
    this.workType = WorkType.LIFT,
    this.logs = const []
  });

  String id;
  String userId;
  String menuCode;
  Timestamp date;
  WorkType workType;
  List<Map<String,double>> logs;

  static WorkLog of(DocumentSnapshot document) {
    if (!document.exists) {
      return new WorkLog();
    }
    return new WorkLog(
      id: document.documentID,
      userId: document['user_id'],
      menuCode: document['menu_code'],
      date: document['date'] ?? '',
      workType: document['work_type'],
      logs: new List<Map<String,double>>.from(document['logs']),
    );
  }

  bool isEmpty() {
    return this.id == '';
  }

  // Delete me after using firebase
  static WorkLog createNewLog(String id, String userId, String menuCode,
      List<WorkoutRowData> workoutRowDatas, Timestamp date, WorkType workType) {
        List<Map<String,double>> logs = new List();
        workoutRowDatas.forEach((data){
          logs.add({"reps": data.reps.toDouble(), "weight": data.weight, "unit": data.weightUnit.toDouble()});
        });
    return new WorkLog(
      id: id,
      userId: userId,
      menuCode: menuCode,
      logs: logs,
      date: date,
      workType: workType,
    );
  }
}
