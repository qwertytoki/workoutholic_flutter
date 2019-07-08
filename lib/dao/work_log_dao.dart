import 'package:workoutholic/dto/work_log.dart';

class WorkLogDao {
  static List<Map<String, int>> getDefaultLogs() {
    List<Map<String, int>> defaultLogs = [];
    defaultLogs.add({"reps": 10, "weight": 60, "unit": 0});
    defaultLogs.add({"reps": 10, "weight": 60, "unit": 0});
    defaultLogs.add({"reps": 10, "weight": 60, "unit": 0});
    defaultLogs.add({"reps": 10, "weight": 60, "unit": 0});
    defaultLogs.add({"reps": 10, "weight": 60, "unit": 0});

    return defaultLogs;
  }
}
