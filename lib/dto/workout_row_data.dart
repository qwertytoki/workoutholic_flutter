import 'package:workoutholic/const/list_for_set_select.dart';

class WorkoutRowData implements ListForSetSelect {
  WorkoutRowData({this.weight = 0, this.weightUnit = 0, this.reps = 0});

  double weight;
  int weightUnit;
  int reps;

  static WorkoutRowData newData(double weight, double weightUnit, double reps) {
    return new WorkoutRowData(
        weight: weight, weightUnit: weightUnit.round(), reps: reps.round());
  }
  static List<WorkoutRowData> translateFromMap(List<Map<String,double>> logs){
    List<WorkoutRowData> list = new List();
    logs.forEach((log){
      list.add(newData(log["weight"],log["unit"],log["reps"]));
    });
    return list;
  }
  static List<WorkoutRowData> getDefaultLogs() {
    List<WorkoutRowData> defaultLogs = [];
    defaultLogs.add(WorkoutRowData.newData(60, 0, 10));
    defaultLogs.add(WorkoutRowData.newData(60, 0, 10));
    defaultLogs.add(WorkoutRowData.newData(60, 0, 10));
    return defaultLogs;
  }
}
