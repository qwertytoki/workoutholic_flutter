import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/login_page.dart';
import 'package:workoutholic/dto/user.dart';
// import 'package:workoutholic/dao/user_dao.dart';

class ProfileEdit extends StatelessWidget {
  final User user;
  @override
  ProfileEdit({@required this.user});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィールの編集"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                _saveProfile(context);
              })
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView(children: <Widget>[
      SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "data",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "1文字以上必要です";
                    } else if (value.length > 20) {
                      return "名前が長すぎます";
                    }
                  }),
            ),
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

  void _saveProfile(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    _auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return LoginPage();
      },
    ));
  }
}
