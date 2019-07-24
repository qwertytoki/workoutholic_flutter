import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workoutholic/screen/login_page.dart';
import 'package:workoutholic/dto/user.dart';
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
          FlatButton(
              child: Text('Logout',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () {
                _signOut(context);
              })
        ],
      ),
      body: buildBody(),
    );
  }
  Widget buildBody(){ 
    return ListView(
      children: <Widget>[
        TextFormField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                hintText: "Type you name.",
                // labelText: Texts.get(r setTextKey.AP_NUMBER_LABEL),
              ),
        ),
        SizedBox(height: 16.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text("ここに名前が入る"),
                ),
              ),
              IconButton(
                icon:Icon(CupertinoIcons.pencil,
                color: Colors.grey),
                onPressed: (){
                  print("pressed");
                },
              ) 
            ]
          ),
        ),
        SizedBox(height: 16.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("ここに自分の目標が入る")
        )
      ]
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
