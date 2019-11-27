// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'dart:async';

class WorkMenuDao {
  static Future<QuerySnapshot> getAllMenus() async {
    return Firestore.instance.collection("workMenu").getDocuments();
  }
}
