import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<FirebaseUser> googleSignIn();
}

class Auth implements BaseAuth{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String,dynamic>> profile;
  PublishSubject loading = PublishSubject();

  // constructor
  Auth(){
    user = Observable(_auth.onAuthStateChanged);
    profile =user.switchMap((FirebaseUser u){
      if(u!= null){
        return _db.collection('users').document(u.uid).snapshots().map((snap) =>snap.data);
      } else {
        return Observable.just({ });
      }
    });
  }
  Future<FirebaseUser> googleSignIn() async{
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    ));

    updateUserData(user);
    print("signed in " + user.displayName);

    loading.add(false);
    return user

  }
  void uodateUserData(FirebaseUser user) async{
    DocumentReference ref = _db.collection('users').document(user.uid);
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _auth.signInWithEmailAndPassword(email:email, password:password );
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email,String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email:email, password:password);
    return user.uid;
  } 

  Future<String> currentUser() async{
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async{
    return _auth.signOut();
  }
} 