import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_set.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/screen/workout_input.dart';
import 'package:workoutholic/dao/work_menu_dao.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';
import 'package:workoutholic/const/list_for_set_select.dart';


class WorkoutMenuSelect extends StatelessWidget {
  @override
  final WorkSet workSet;
  WorkoutMenuSelect({@required this.workSet});
  // final WorkoutSet workoutSet;
  // WorkoutMenuSelect({Key key, @required this.workoutSet}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workSet.nameJa),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    List<WorkMenu> menus = WorkMenuDao.getMenus(this.workSet.menus);
    List<ListForSetSelect> displayList = [];
    menus.forEach((menu) {
      displayList.add(menu);
      // ワークアウト履歴があればそれを、なければデフォルトを表示する
      displayList.add(WorkLog());
    });
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: displayList.length,
        itemBuilder: (context, int index) {
          final item = displayList[index];
          if (item is WorkMenu) {
            return ListTile(
              title: Text(
                item.nameJa,
                style: Theme.of(context).textTheme.headline,
              ),
            );
          }else if(item is WorkLog){
            if(item.weights.length == 0){
              WorkLogDao.getDefaultWeight().forEach((weight){
                // ここにworkLog埋め込む 
                // 60kg 5回 みたいなね。
              });
            }
          }
        });
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black38,
            ),
        padding: const EdgeInsets.all(16.0),
        itemCount: menus.length,
        itemBuilder: (context, int index) {
          return ListTile(
            title: Text(
              menus[index].nameJa,
              style: const TextStyle(fontSize: 18.0),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WorkoutInputPage(workMenu: menus[index])),
            ),
          );
        });
  }

// for mock data
  List<WorkMenu> createMockData() {
    return null;
  }

  // Widget _buildBody(BuildContext context) {
  //   // return StreamBuilder<QuerySnapshot>(
  //   //     stream: WorkoutMenu.getMenuFromWorkoutSet(workoutSet.workoutIds),
  //   //     builder: (context, snapshot) {
  //   //       if (!snapshot.hasData) return LinearProgressIndicator();
  //   //       return _buildList(context, snapshot.data.documents);
  //   //     });
  // }

  // Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return ListView(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  //   );
  // }

  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final workoutSet = WorkoutSet.fromSnapshot(data);
  //   return Padding(
  //     key: ValueKey(workoutSet.setName),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: ListTile(
  //         title: Text(workoutSet.setName),
  //         // trailing: Text(record.votes.toString()),
  //         // onTap: () => Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => WorkoutMenuSelect(workoutSet:workoutSet)),
  //         // ),
  //       ),
  //     ),
  //   );
  // }
}
