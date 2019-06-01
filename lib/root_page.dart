// import 'package:flutter/material.dart';
// import 'screen/login_page.dart';
// import 'package:workoutholic/auth.dart';
// import 'screen/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RootPage extends StatefulWidget {
//   RootPage({this.auth});
//   final BaseAuth auth;

//   @override
//   State<StatefulWidget> createState() => new _RootPageState();
// }

// class _RootPageState extends State<RootPage> {
//   FirebaseUser _user;

//   //ビルドが呼ばれたときときいつも呼ばれる
//   initState() {
//     super.initState();
//     widget.auth.currentUser().then((user) {
//       setState(() {
//         _user = user;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_user == null) {
//       return new LoginPage(
//         auth: widget.auth,
//       );
//     } else {
//       return new HomePage(
//         auth: widget.auth,
//       );
//     }
//   }
// }
