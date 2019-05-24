import 'package:flutter/material.dart';
import 'package:workoutholic/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new Container(
            // body: Center(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () => signInWithGoogle,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Login with Google'),
                )
              ],
            )));
  }

  void signInWithGoogle() async {
    print("ログインを試す");
    widget.auth.googleSignIn();
  }
}
