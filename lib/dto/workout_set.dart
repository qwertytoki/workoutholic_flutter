import 'package:workoutholic/const/list_for_set_select.dart';

class WorkoutSet implements ListForSetSelect {
  WorkoutSet({this.weight = 0, this.weightUnit = 0, this.reps = 0});

  num weight;
  num weightUnit;
  num reps;

  static WorkoutSet newData(num weight, num weightUnit, num reps) {
    return new WorkoutSet(
        weight: weight, weightUnit: weightUnit, reps: reps);
  }

  static List<WorkoutSet> translateFromMap(List<Map<String,num>> logs) {
    List<WorkoutSet> list = new List();
    logs.forEach((log) {
      list.add(newData(log["weight"], log["unit"], log["reps"]));
    });
    return list;
  }

  static List<WorkoutSet> getDefaultLogs() {
    List<WorkoutSet> defaultLogs = [];
    defaultLogs.add(WorkoutSet.newData(60, 0, 10));
    defaultLogs.add(WorkoutSet.newData(60, 0, 10));
    defaultLogs.add(WorkoutSet.newData(60, 0, 10));
    return defaultLogs;
  }
}
