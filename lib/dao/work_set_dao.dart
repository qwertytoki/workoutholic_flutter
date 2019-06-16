import 'package:flutter/material.dart';
import 'package:workoutholic/dto/work_set.dart';

class WorkSetDao{
  static List<WorkSet> genarateMockData(){
    List<WorkSet> workSets = new List();
    workSets.add(WorkSet.createNewSet(
        "id1", "", "Big3", "Big3", "The day condition is perfect", null, true));
    workSets.add(WorkSet.createNewSet(
        "id2", "", "Chest Day", "胸の日", "Every Wednesday", null, true));
    workSets.add(WorkSet.createNewSet(
        "id3", "", "Legs Day", "脚の日", "Every Monday", null, true));
    return workSets;
  }
}