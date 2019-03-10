import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  void signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email:email, password:password );
  }
} 