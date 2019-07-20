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

class WorkoutPlanSelectPage extends StatelessWidget {
  @override
  // final DateTime selectedDate;
  // WorkoutPlanSelect({Key key, @required this.selectedDate}) : super(key: key);

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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    List<WorkPlan> workPlans = generateMockData();
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
                    builder: (context) => WorkoutMenuSelect(workPlan: item)),
              ),
            );
          } else if (item is WorkMenu) {
            return ListTile(
                title: Text(item.nameJa),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkoutMenuSelect(workPlan: item.workPlan)),
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
          ;
        });
  }

  // Firebaseに置き換える予定なので隔離してる
  List<WorkPlan> generateMockData() {
    return WorkPlanDao.genarateMockData();
  }

// firebase使うなら以下のソース
  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection('workoutPlan').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return LinearProgressIndicator();
  //       return _buildList(context, snapshot.data.documents);
  //     },
  //   );
  // }

  // Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return ListView(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  //   );
  // }
  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final workoutPlan = WorkoutPlan.fromSnapshot(data);
  //   return Padding(
  //     key: ValueKey(workoutPlan.setName),
  //     padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: ListTile(
  //         title: Text(workoutPlan.setName),
  //         // trailing: Text(record.votes.toString()),
  //         onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) =>
  //                       WorkoutMenuSelect(workoutPlan: workoutPlan)),
  //             ),
  //       ),
  //     ),
  //   );
  // }
}
