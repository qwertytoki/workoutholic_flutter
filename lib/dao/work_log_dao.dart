import 'package:workoutholic/dto/work_log.dart';

class WorkLogDao{
  static List<int> getDefaultReps(){
    return  [10, 10, 10];
  }
  static List<int> getDefaultWeight(){
    return [60,60,60];
  }
}