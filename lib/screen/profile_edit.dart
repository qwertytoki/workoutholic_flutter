import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dao/user_dao.dart';
import 'package:workoutholic/screen/profile_page.dart';

class ProfileEdit extends StatelessWidget {
  final User user;
  @override
  ProfileEdit({@required this.user});
  final nameController = TextEditingController();
  final goalController = TextEditingController();

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
        child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "名前",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "1文字以上必要です";
              } else if (value.length > 20) {
                return "名前が長すぎます";
              }
            }),
      ),
      SizedBox(
        height: 16.0,
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(children: <Widget>[
            Expanded(
                child: TextFormField(
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              controller: goalController,
              decoration: InputDecoration(
                labelText: "目標",
              ),
            ))
          ]))
    ]);
  }

  void _saveProfile(BuildContext context) async {
    user.displayName = this.nameController.text;
    user.description = this.goalController.text;
    UserDao.updateUser(user);
    Navigator.of(context).pop();
  }
}
