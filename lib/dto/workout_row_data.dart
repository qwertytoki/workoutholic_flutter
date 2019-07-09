import 'package:workoutholic/const/list_for_set_select.dart';

class WorkoutRowData implements ListForSetSelect{
    WorkoutRowData({
    this.weight = 0,
    this.weightUnit = 0,
    this.reps = 0
  });

  int weight;
  int weightUnit;
  int reps;

}