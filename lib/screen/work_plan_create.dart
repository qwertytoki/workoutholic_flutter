import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
// import 'package:workoutholic/screen/work_plan_add_menus.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkPlanCreatePage extends StatefulWidget {
  final User user;
  final DateTime date;
  final List<WorkMenu> paramMenus;
  @override
  WorkPlanCreatePage(
      {@required this.user, @required this.date, this.paramMenus});
  _WorkPlanCreateState createState() => _WorkPlanCreateState();
}

class _WorkPlanCreateState extends State<WorkPlanCreatePage> {
  List<WorkMenu> selectedMenus = widget.paramMenus;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新しいプランを作成"),
          actions: <Widget>[
            FlatButton(
                child: Text('完了',
                    style: TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: () {
                  _saveLogs();
                  Navigator.pop(context);
                })
          ],
        ),
        body: ListView(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: new InputDecoration(hintText: "プラン名"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  ListTile(
                      title: Text("メニューを追加", textAlign: TextAlign.center),
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkPlanAddMenusPage(
                                      user: widget.user,
                                      date: widget.date))).then((menus) {
                            setState(() {
                              selectedMenus = menus;
                            });
                          }))
                ],
              )),
        ]));
  }

  _saveLogs() {
    // planテーブルに登録
  }
}
