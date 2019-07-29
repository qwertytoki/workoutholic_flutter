import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/login_page.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/screen/profile_edit.dart';
// import 'package:workoutholic/dao/user_dao.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  @override
  ProfilePage({@required this.user});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィール"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                _signOut(context);
              })
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(children: <Widget>[
      SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(children: <Widget>[
          Expanded(
            child: Container(
              child: Text(this.user.displayName),
            ),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.pencil, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEdit(user: this.user),
                  ));
            },
          )
        ]),
      ),
      SizedBox(
        height: 16.0,
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(this.user.description))
    ]);
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
