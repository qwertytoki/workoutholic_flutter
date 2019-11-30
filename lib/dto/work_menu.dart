import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/work_plan.dart';

class WorkMenu implements ListForSetSelect {
  WorkMenu({
    this.id = '',
    this.code = '',
    this.nameEn = '',
    this.nameJa = '',
    this.photoURL = '',
    this.workType = '',
  });

  String id;
  String code;
  String nameEn;
  String nameJa;
  String photoURL;
  String workType;
  // DataBaseには持たない。ロジック上で使う
  WorkPlan workPlan;

  static WorkMenu of(DocumentSnapshot document) {
    if (!document.exists) {
      return new WorkMenu();
    }
    return new WorkMenu(
      id: document.documentID,
      code: document['code'],
      nameEn: document['name_en'],
      nameJa: document['name_ja'],
      photoURL: document['photo_url'] ?? '',
      workType: document['work_type'],
    );
  }

  bool isEmpty() {
    return this.id == '';
  }

  Map<String, Object> toMapForMenu() {
    Map<String, Object> data = new Map();
    data.putIfAbsent('code', () => code);
    data.putIfAbsent('name_en', () => nameEn);
    data.putIfAbsent('name_ja', () => nameJa);
    data.putIfAbsent('photo_url', () => photoURL);
    data.putIfAbsent('work_type', () => workType);
    return data;
  }

  // Delete me after using firebase
  static WorkMenu createNewMenu(String id, String code, String nameEn,
      String nameJa, String photoURL, String workType) {
    return new WorkMenu(
      id: id,
      code: code,
      nameEn: nameEn,
      nameJa: nameJa,
      photoURL: photoURL,
      workType: workType,
    );
  }
  static WorkMenu generateDisplayMenu(String code, String nameEn,String nameJa) {
    return new WorkMenu(
      code: code,
      nameEn: nameEn,
      nameJa: nameJa
    );
  }
}
