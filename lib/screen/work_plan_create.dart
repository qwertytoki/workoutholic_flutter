import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dto/work_plan.dart';
import 'package:workoutholic/dao/work_plan_dao.dart';
import 'package:workoutholic/screen/work_plan_add_menus.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkPlanCreatePage extends StatefulWidget {
  final User user;
  final DateTime date;
  @override
  WorkPlanCreatePage({@required this.user, @required this.date});
  _WorkPlanCreateState createState() => _WorkPlanCreateState();
}

class _WorkPlanCreateState extends State<WorkPlanCreatePage> {
  List<WorkMenu> _selectedMenus;
  TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    nameController = TextEditingController();
    if (_selectedMenus == null) {
      _selectedMenus = new List();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("新しいプランを作成"),
          actions: <Widget>[
            FlatButton(
                child: Text('完了',
                    style: TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: () {
                  _savePlan(context);
                })
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _selectedMenus.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                        controller: nameController,
                        decoration: new InputDecoration(hintText: "プラン名"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "1文字以上必要です";
                          } else if (value.length > 20) {
                            return "名前が長すぎます";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 16.0,
                    )
                  ]));
            } else if (index > _selectedMenus.length) {
              return ListTile(
                  title: Text("メニューを追加", textAlign: TextAlign.center),
                  onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkPlanAddMenusPage(
                                      user: widget.user,
                                      date: widget.date,
                                      selectedMenus: _selectedMenus)))
                          .then((menus) {
                        setState(() {
                          _selectedMenus = menus;
                        });
                      }));
            }
            WorkMenu menu = _selectedMenus[index - 1];
            return ListTile(
              title: Text(menu.nameJa),
            );
          },
        ));
  }

  void _savePlan(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      WorkPlan plan = WorkPlan.createNewPlan(
          widget.user.uid,
          nameController.text,
          nameController.text,
          nameController.text,
          "",
          WorkPlan.generateMenusFormMenuDto(_selectedMenus)
          );
      WorkPlanDao.insertPlan(plan);
      Navigator.pop(context);
    }
  }
}
