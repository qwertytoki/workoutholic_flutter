import 'package:flutter/material.dart';

class AddSet extends StatelessWidget {
  @override
  // final WorkoutSet workey key, @required this.workoutSetoutSet;
  // WorkoutInputPage({K}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = new Scaffold(
      appBar: AppBar(
        title: Text("Create New Set"),
        ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                hintText: Texts.get(TextKey.AP_NUMBER_HINT),
                labelText: Texts.get(TextKey.AP_NUMBER_LABEL),
              ),
              controller: _userNumberController,
              // inputFormatters: [new UserNumberTextFormatter()],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: 32.0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new Builder(
                      builder: (BuildContext context) {
                        return OutlineButton(
                          child: Text(Texts.get(TextKey.AP_ADD_BUTTON_LABEL)),
                          onPressed: () => _inviteUser(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                children: <Widget>[
                  Text(Texts.get(TextKey.AP_MEMBERS_LABEL)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: members.map((uid) {
                  return FutureBuilder(
                    future: UserDao.getUserByUid(uid),
                    builder:
                        (BuildContext context, AsyncSnapshot<User> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        User user = snapshot.data;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: UserAvatarName(
                            name: user.displayName,
                            avatarImageUrl: user.photoUrlMobile,
                            avatarUid: user.uid,
                            uid: widget.uid,
                          ),
                        );
                      }
                      return new Container();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
    // this WillPopScope is not needed...? #105
    return WillPopScope(
      child: scaffold,
      onWillPop: () {
        Navigator.of(context).pop(members);
      },
    );
  }
}
