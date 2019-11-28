import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:workoutholic/dto/work_menu.dart';

class WorkMenuDao {
  static Future<QuerySnapshot> getAllMenusFuture() async {
    return Firestore.instance.collection("workMenu").getDocuments();
  }

  static Future<List<WorkMenu>> getAllMenus() async {
    QuerySnapshot snapshot = await Firestore.instance.collection("workMenu").getDocuments();
    List<WorkMenu> list = new List();
    snapshot.documents.forEach((s){
      list.add(WorkMenu.of(s));
    });
    return list;
  }
}
