import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_set.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/screen/workout_input.dart';
import 'package:workoutholic/dao/work_menu_dao.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/dto/workout_row_data.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:workoutholic/const/picker_data.dart';
import 'dart:convert';

class WorkoutMenuSelect extends StatefulWidget {
  @override
  final WorkSet workSet;
  WorkoutMenuSelect({@required this.workSet});

  _WorkoutMenuSelectState createState() => _WorkoutMenuSelectState();
}

class _WorkoutMenuSelectState extends State<WorkoutMenuSelect> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListForSetSelect> displayList = [];
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.workSet.nameJa),
        actions: <Widget>[
          FlatButton(
              child: Text('完了',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () => print("pressed"),
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
    List<WorkMenu> menus = WorkMenuDao.getMenus(widget.workSet.menus);
    menus.forEach((menu) {
      displayList.add(menu);
      // FIXME ワークアウト履歴があればそれを、なければデフォルトを表示する
      // WorkLog log = menu.getWorkLog();
      WorkLog log = new WorkLog();
      if (log.logs.length == 0) {
        displayList.addAll(WorkoutRowData.getDefaultLogs());
      } else {
        displayList.addAll(WorkoutRowData.translateFromMap(log.logs));
      }
    });
  }

  Widget _buildList(BuildContext context) {
    
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
          } else if (item is WorkoutRowData) {
            String weight = item.weight.toString();
            String weightUnit = item.weightUnit == 0 ? " kg " : " lbs ";
            String reps = item.reps.toString();
            String repsUnit = " 回" ;
            return ListTile(
              title: Text(weight + weightUnit + reps + repsUnit),
              onTap: () {
                showPickerArray(context, displayList.indexOf(item));
              },
            );
          }
        });
  }

  showPickerArray(BuildContext context, int indexOfList) {
    WorkoutRowData rowData = displayList[indexOfList];
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
            displayList[indexOfList] = WorkoutRowData.newData(
                double.parse(selectedVals[0]),
                weightUnit,
                double.parse(selectedVals[2]));
          });
        }).showDialog(context);
  }
  int getWeightForPicker(double weight){ 
    if(weight <= 40){
      return weight.round()-1;
    }
    weight = weight-40;
    int returnNum = (weight/2.5).round();
    return returnNum+39;
  }
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
