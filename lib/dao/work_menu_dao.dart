import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkMenuDao {
  static List<WorkMenu> genarateMockData() {
    List<WorkMenu> workMenus = new List();
    workMenus.add(WorkMenu.createNewMenu(
        "id1", "bench_press", "Bench Press", "ベンチプレス", "URL1", "LIFT"));
    workMenus.add(WorkMenu.createNewMenu(
        "id2", "squat", "Squat", "スクワット", "URL2", "LIFT"));
    workMenus.add(WorkMenu.createNewMenu(
        "id3", "dead_lift", "Dead Lift", "デッドリフト", "URL3", "LIFT"));
    workMenus.add(WorkMenu.createNewMenu("id4", "incline_bench_press",
        "Incline Bench Press", "インクライン ベンチプレス", "URL4", "LIFT"));
    workMenus.add(WorkMenu.createNewMenu("id5", "decline_bench_press",
        "Decline Bench Press", "デクライン ベンチプレス", "URL5", "LIFT"));
    workMenus.add(
        WorkMenu.createNewMenu("id6", "lunge", "Lunge", "ランジ", "URL6", "LIFT"));
    workMenus.add(WorkMenu.createNewMenu("id7", "leg_extension",
        "Leg Extension", "レッグエクステンション", "URL7", "LIFT"));
    return workMenus;
  }

  static List<WorkMenu> getMenus(List<String> menuList) {
    // FireStoreに書き換え
    List<WorkMenu> allMenus = genarateMockData();
    List<WorkMenu> resultMenus = new List();
    allMenus.forEach((menu) {
      if (menuList.contains(menu.code)) {
        resultMenus.add(menu);
      }
    });
   return resultMenus;
  }
  // static Stream<QuerySnapshot> getMenus2(){
  //   return Firestore.instance
  //   .collection('workMenu')
  // }
}
