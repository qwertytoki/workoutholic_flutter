import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';

class TransitionPage extends StatelessWidget {
  final User user;
  @override
  TransitionPage({@required this.user});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("グラフ"),
      ),
    );
  }
}
