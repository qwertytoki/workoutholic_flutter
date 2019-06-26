import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.uid = '',
    this.displayName = '',
    this.description = '',
    this.coverImageUrlMobile = '',
    this.photoUrlMobile = '',
    this.language = '',
  });

  String uid;
  String displayName;
  String description;
  String coverImageUrlMobile;
  String photoUrlMobile;
  String language;

  static User of(DocumentSnapshot document) {
    if (!document.exists) {
      return new User();
    }
    return new User(
      uid: document.documentID,
      displayName: document['display_name'],
      description: document['description'],
      coverImageUrlMobile: document['cover_image_url_mobile'] ?? '',
      photoUrlMobile: document['photo_url_mobile'] ?? '',
      language: document['language_code'],
    );
  }

  bool isEmpty() {
    return this.uid == '';
  }

  Map<String, Object> toMapForUser() {
    Map<String, Object> data = new Map();
    data.putIfAbsent('photo_url_mobile', () => photoUrlMobile);
    data.putIfAbsent('display_name', () => displayName);
    data.putIfAbsent('cover_image_url_mobile', () => coverImageUrlMobile);
    data.putIfAbsent('description', () => description);
    data.putIfAbsent('language_code', () => language);
    return data;
  }
}
