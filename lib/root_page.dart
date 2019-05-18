import 'package:flutter/material.dart';
import 'screen/login_page.dart';
import 'package:workoutholic/auth.dart';
import 'screen/home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    //ビルドが呼ばれたときときいつも呼ばれる
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        authStatus = userId ==null ? AuthStatus.notSignedIn:AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState((){
      authStatus = AuthStatus.signedIn;
    });
  }
  void _signedOut(){
    setState((){
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn:_signedIn,
        );
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
