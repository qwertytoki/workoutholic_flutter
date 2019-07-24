import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/login_page.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dao/user_dao.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  @override
  ProfilePage({@required this.user});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          FlatButton(
              child: Text('Logout',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () {
                _signOut(context);
              })
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    _auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return LoginPage();
      },
    ));
  }
}
