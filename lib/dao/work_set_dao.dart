import 'package:flutter/material.dart';
import 'package:workoutholic/dto/work_set.dart';

class WorkSetDao{
  static List<WorkSet> genarateMockData(){
    List<WorkSet> workSets = new List();
    List<String> menus1 = new List();
    menus1.add("bench_press");
    menus1.add("squat");
    menus1.add("dead_lift");
    workSets.add(WorkSet.createNewSet(
        "id1", "", "Big3", "Big3", "The day condition is perfect", menus1, true));
    List<String> menus2 = new List();
    menus2.add("bench_press");
    menus2.add("incline_bench_press");
    menus2.add("decline_bench_press");
    workSets.add(WorkSet.createNewSet(
        "id2", "", "Chest Day", "胸の日", "Every Wednesday", menus2, true));
    List<String> menus3 = new List();
    menus3.add("squat");
    menus3.add("lunge");
    menus3.add("leg_extenion");
    workSets.add(WorkSet.createNewSet(
        "id3", "", "Legs Day", "脚の日", "Every Monday", menus3, true));
    return workSets;
  }
}