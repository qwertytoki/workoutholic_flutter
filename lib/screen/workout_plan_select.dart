import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:workoutholic/dto/workout_plan.dart';
import 'package:workoutholic/screen/workout_menu_select.dart';
import 'package:workoutholic/dto/work_plan.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/dao/work_plan_dao.dart';
import 'package:workoutholic/dao/work_menu_dao.dart';
import 'package:workoutholic/screen/add_set.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/user.dart';

class WorkoutPlanSelectPage extends StatelessWidget {
  final User user;
  final DateTime date;
  @override
  WorkoutPlanSelectPage({@required this.user, @required this.date});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("トレーニングを選択"),
        actions: <Widget>[
          FlatButton(
              child: Text('Add',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSetPage(),
                    ),
                  ))
        ],
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context)  {
    List<WorkPlan> workPlans;
    loadPlan(user.uid).then((planList){
      workPlans = planList;
    });
    // List<WorkPlan> workPlans = generateMockData();
    List<ListForSetSelect> displayList = [];
    workPlans.forEach((set) {
      displayList.add(set);
      List<WorkMenu> menuList = WorkMenuDao.getMenus(set.menus);
      menuList.forEach((menu) {
        menu.workPlan = set;
        displayList.add(menu);
      });
      displayList.add(new Separator());
    });
    displayList.add(new AddNewSet());

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: displayList.length,
        itemBuilder: (context, int index) {
          final item = displayList[index];
          if (item is WorkPlan) {
            return ListTile(
              title: Text(
                item.nameJa,
                style: Theme.of(context).textTheme.headline,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkoutMenuSelect(
                        user: this.user, workPlan: item, date: this.date)),
              ),
            );
          } else if (item is WorkMenu) {
            return ListTile(
                title: Text(item.nameJa),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutMenuSelect(
                              user: this.user,
                              workPlan: item.workPlan,
                              date: this.date)),
                    ));
          } else if (item is Separator) {
            return Divider(color: Colors.black38);
          } else {
            return ListTile(
                title: Text("トレーニングプランを新規作成", textAlign: TextAlign.center),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSetPage(),
                      ),
                    ));
          }
        });
  }
  Future<List<WorkPlan>> loadPlan(String uid) async{
    return await WorkPlanDao.getPlansByUser(uid);
  }

  // Firebaseに置き換える予定なので隔離してる
  List<WorkPlan> generateMockData() {
    return WorkPlanDao.genarateMockData();
  }
}
