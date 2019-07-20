import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/const/list_for_set_select.dart';

class WorkPlan implements ListForSetSelect {
  WorkPlan({
    this.id = '',
    this.userId = '',
    this.nameEn = '',
    this.nameJa = '',
    this.note = '',
    this.menus = const[],
    this.isDefault = false,
  });

  String id;
  String userId;
  String nameEn;
  String nameJa;
  String note;
  List<String> menus;
  bool isDefault;

  static WorkPlan of(DocumentSnapshot document) {
    if (!document.exists) {
      return new WorkPlan();
    }
    return new WorkPlan(
      id: document.documentID,
      userId: document['user_id'],
      nameEn: document['name_en'],
      nameJa: document['name_ja'],
      note: document['note'] ?? '',
      menus: new List<String>.from(document['menus']),
      isDefault: document['is_default']
    );
  }

  bool isEmpty() {
    return this.id == '';
  }

  Map<String, Object> toMapForSet() {
    Map<String, Object> data = new Map();
    data.putIfAbsent('user_id', () => userId);
    data.putIfAbsent('name_en', () => nameEn);
    data.putIfAbsent('name_ja', () => nameJa);
    data.putIfAbsent('note', () => note);
    data.putIfAbsent('menus', () => menus);
    data.putIfAbsent('is_default', () => isDefault);
    return data;
  }

  // Delete me after using firebase
  static WorkPlan createNewSet(
      String id,
      String userId,
      String nameEn,
      String nameJa,
      String note,
      List<String> menus,
      bool isDefault) {
    return new WorkPlan(
      id: id,
      userId: userId,
      nameEn: nameEn,
      nameJa: nameJa,
      note: note,
      menus: menus,
      isDefault: isDefault,
    );
  }
}
