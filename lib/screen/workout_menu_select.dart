import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_plan.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/dao/work_menu_dao.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/workout_set.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:workoutholic/const/picker_data.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:workoutholic/screen/home_page.dart';
import 'package:workoutholic/dto/user.dart';

class WorkoutMenuSelect extends StatefulWidget {
  final WorkPlan workPlan;
  final User user;
  final DateTime date;
  @override
  WorkoutMenuSelect(
      {@required this.user, @required this.workPlan, @required this.date});

  _WorkoutMenuSelectState createState() => _WorkoutMenuSelectState();
}

class _WorkoutMenuSelectState extends State<WorkoutMenuSelect> {
  final Set<WorkMenu> _saved = Set<WorkMenu>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListForSetSelect> displayList = [];
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.workPlan.nameJa),
        actions: <Widget>[
          FlatButton(
            child: Text('完了',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(user: widget.user))),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildList(context);
  }

  @override
  void initState() {
    super.initState();
    List<WorkMenu> menus = WorkMenuDao.getMenus(widget.workPlan.menus);
    menus.forEach((menu) {
      displayList.add(menu);
      // FIXME ワークアウト履歴があればそれを、なければデフォルトを表示する
      // WorkLog log = menu.getWorkLog();
      WorkLog log = new WorkLog();
      if (log.logs.length == 0) {
        displayList.addAll(WorkoutSet.getDefaultLogs());
      } else {
        displayList.addAll(WorkoutSet.translateFromMap(log.logs));
      }
      displayList.add(new AddNewSet());
      displayList.add(new Separator());
    });
    displayList.add(new AddNewMenu());
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: displayList.length,
        itemBuilder: (context, int index) {
          final item = displayList[index];
          final bool alreadySaved = _saved.contains(item);
          if (item is WorkMenu) {
            return ListTile(
              title: Text(
                item.nameJa,
                style: Theme.of(context).textTheme.headline,
              ),
              trailing: Icon(
                // Add the lines from here...
                alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
                color: alreadySaved ? Colors.blue : null,
              ),
              onTap: () {
                // Add 9 lines from here...
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(item);
                  } else {
                    _saved.add(item);
                  }
                });
              },
            );
          } else if (item is WorkoutSet) {
            String id = new Uuid().hashCode.toString();
            String weight = item.weight.toString();
            String weightUnit = item.weightUnit == 0 ? " kg " : " lbs ";
            String reps = item.reps.toString();
            String repsUnit = " 回";
            return Dismissible(
                key: Key(id),
                onDismissed: (direction) {
                  if (displayList.contains(item)) {
                    setState(() {
                      displayList.remove(item);
                    });
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("削除しました")));
                  }
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(weight + weightUnit + reps + repsUnit),
                  onTap: () {
                    showPickerArray(context, displayList.indexOf(item));
                  },
                ));
          } else if (item is Separator) {
            return Divider(color: Colors.black38);
          } else if (item is AddNewSet) {
            return ListTile(
                title: Text("セットを追加"),
                onTap: () => {
                      setState(() {
                        displayList.insert(
                            index, WorkoutSet.newData(60, 0, 10));
                      }),
                    });
          } else {
            return ListTile(
                title: Text("メニューを追加", textAlign: TextAlign.center),
                onTap: () => print("hoge"));
          }
        });
  }

  showPickerArray(BuildContext context, int indexOfList) {
    WorkoutSet rowData = displayList[indexOfList];
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData2), isArray: true),
        hideHeader: true,
        title: Text("結果を入力"),
        // 初期値
        selecteds: [getWeightForPicker(rowData.weight), 0, rowData.reps, 0],
        onConfirm: (Picker picker, List value) {
          setState(() {
            List<String> selectedVals = picker.getSelectedValues();
            double weightUnit = selectedVals[1] == 'kg' ? 0 : 1;
            displayList[indexOfList] = WorkoutSet.newData(
                double.parse(selectedVals[0]),
                weightUnit,
                double.parse(selectedVals[2]));
          });
        }).showDialog(context);
  }

  int getWeightForPicker(double weight) {
    if (weight <= 40) {
      return weight.round() - 1;
    }
    weight = weight - 40;
    int returnNum = (weight / 2.5).round();
    return returnNum + 39;
  }
}

// Widget _buildBody(BuildContext context) {
//   // return StreamBuilder<QuerySnapshot>(
//   //     stream: WorkoutMenu.getMenuFromWorkoutPlan(workoutPlan.workoutIds),
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
//   final workoutPlan = WorkoutPlan.fromSnapshot(data);
//   return Padding(
//     key: ValueKey(workoutPlan.setName),
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       child: ListTile(
//         title: Text(workoutPlan.setName),
//         // trailing: Text(record.votes.toString()),
//         // onTap: () => Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => WorkoutMenuSelect(workoutPlan:workoutPlan)),
//         // ),
//       ),
//     ),
//   );
// }
