import 'dart:async';

import 'package:workoutholic/dto/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDao {
  static const String COLLECTION_USER = 'user';

  static Future<DocumentSnapshot> getUser(
      Future<FirebaseUser> firebaseUserFuture) async {
    FirebaseUser firebaseUser = await firebaseUserFuture;
    if (firebaseUser != null) {
      return Firestore.instance
          .collection(COLLECTION_USER)
          .document(firebaseUser.uid)
          .get();
    }
    return Future<DocumentSnapshot>.value(null);
  }

  static Future<User> getUserByUid(String uid) {
    Future<DocumentSnapshot> snapshot =
        Firestore.instance.collection(COLLECTION_USER).document(uid).get();
    return snapshot.then<User>((snap) {
      return User.of(snap);
    });
  }

  static Future<void> addUser(String uid, String userNumber, String photoUrl,
      String displayName, String language) async {
    User user = new User(
      photoUrlMobile: photoUrl,
      displayName: displayName,
      language: language,
    );
    Firestore.instance
        .collection(COLLECTION_USER)
        .document(uid)
        .setData(user.toMapForUser());
  }

  static Future<void> updateUser(User user) {
    return Firestore.instance
        .collection(COLLECTION_USER)
        .document(user.uid)
        .setData(user.toMapForUser(), merge: true);
  }

  static Future<void> updateLanguage(String uid, String language) {
    return Firestore.instance
        .collection(COLLECTION_USER)
        .document(uid)
        .updateData({'language_code': language});
  }
}
