import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkPlan implements ListForSetSelect {
  WorkPlan({
    this.id = '',
    this.userId = '',
    this.code = '',
    this.nameEn = '',
    this.nameJa = '',
    this.note = '',
    this.menus = const [],
  });

  String id;
  String userId;
  String code;
  String nameEn;
  String nameJa;
  String note;
  List<WorkMenu> menus;


  static WorkPlan of(DocumentSnapshot document) {
    if (!document.exists) {
      return new WorkPlan();
    }
    return new WorkPlan(
        id: document.documentID,
        userId: document['user_id'],
        code: document['code'],
        nameEn: document['name_en'],
        nameJa: document['name_ja'],
        note: document['note'] ?? '',
        menus: _translateToMenus(document['menus'])
    );
  }
  static List<WorkMenu> _translateToMenus(List<dynamic> list){
    List<WorkMenu> menus = new List();
    list.forEach((document){
      menus.add(WorkMenu.generateDisplayMenu(document['code'], document['name_en'], document['name_ja']));
      
    });
    return menus;
  }

  bool isEmpty() {
    return this.id == '';
  }

  static Map<String, Object> toMap(WorkPlan plan) {
    Map<String, Object> data = new Map();
    data.putIfAbsent('user_id', () => plan.userId);
    data.putIfAbsent('code', () => plan.code);
    data.putIfAbsent('name_en', () => plan.nameEn);
    data.putIfAbsent('name_ja', () => plan.nameJa);
    data.putIfAbsent('note', () =>plan. note);
    data.putIfAbsent('menus', () => plan.menus);
    return data;
  }

  // Delete me after using firebase
  static WorkPlan createNewSet(String id, String userId, String code, String nameEn,
      String nameJa, String note, List<WorkMenu> menus) {
    return new WorkPlan(
      id: id,
      userId: userId,
      code: code,
      nameEn: nameEn,
      nameJa: nameJa,
      note: note,
      menus: menus,
    );
  }
}
