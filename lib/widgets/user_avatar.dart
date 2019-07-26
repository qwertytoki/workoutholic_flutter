import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget{
  const UserAvatar({
    @required this.uId,
    @required this.avatarUid,
    @required this.avatarImageUrl,
    @required this.name,
  });

  final String uId;
  final String avatarUid;
  final String avatarImageUrl;
  final String name;

  @override 
  Widget build(BuildContext context){
    return Row(children: <Widget>[
      getAvatarFromGoogle(),
      Padding(padding: EdgeInsets.only,)

  }
}