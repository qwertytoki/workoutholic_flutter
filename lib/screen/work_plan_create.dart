import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/screen/work_plan_add_menus.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkPlanCreatePage extends StatefulWidget {
  final User user;
  final DateTime date;
  @override
  WorkPlanCreatePage(
      {@required this.user, @required this.date});
  _WorkPlanCreateState createState() => _WorkPlanCreateState();
}

class _WorkPlanCreateState extends State<WorkPlanCreatePage> {
  List<WorkMenu> _selectedMenus;
  Widget build(BuildContext context) {
    if(_selectedMenus == null){
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
                  _saveLogs();
                  Navigator.pop(context);
                })
          ],
        ),
        body: 
        ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _selectedMenus.length+1,
          itemBuilder: (context,index){
            if(index>_selectedMenus.length){
              return ListTile(
                      title: Text("メニューを追加", textAlign: TextAlign.center),
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkPlanAddMenusPage(
                                      user: widget.user,
                                      date: widget.date,
                                      selectedMenus: _selectedMenus))).then((menus) {
                            setState(() {
                              _selectedMenus = menus;
                            });
                          }));
            }
            WorkMenu menu = _selectedMenus[index];
            return ListTile(
              title: Text(menu.nameJa),
            );
          },
        )
        // ListView(children: <Widget>[
        //   Padding(
        //       padding: EdgeInsets.all(16.0),
        //       child: Column(
        //         children: <Widget>[
        //           TextFormField(
        //             decoration: new InputDecoration(hintText: "プラン名"),
        //           ),
        //           SizedBox(
        //             height: 8.0,
        //           ),
        //           ListTile(
        //               title: Text("メニューを追加", textAlign: TextAlign.center),
        //               onTap: () => Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => WorkPlanAddMenusPage(
        //                               user: widget.user,
        //                               date: widget.date,
        //                               selectedMenus: _selectedMenus))).then((menus) {
        //                     setState(() {
        //                       _selectedMenus = menus;
        //                     });
        //                   }))
        //         ],
        //       )),
        // ])
        );
  }

  _saveLogs() {
    // planテーブルに登録
  }
}
