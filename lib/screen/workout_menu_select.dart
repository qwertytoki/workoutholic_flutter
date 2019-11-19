import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/work_plan.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/widget/circular_load.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/const/work_type.dart';
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
  final Set<WorkMenu> _done = Set<WorkMenu>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListForSetSelect> _displayList = new List();
  List<WorkLog> _existLogs = new List();

  @override
  void initState() {
    super.initState();
    WorkLogDao.getLogByUserAndDate(widget.user.uid, widget.date).then((list) {
      setState(() {
        _existLogs = list;
        _displayList = _generateDisplayList(_existLogs);
      });
    });
  }

  List<ListForSetSelect> _generateDisplayList([List<WorkLog> existLogs]) {
    if (existLogs == null) {
      existLogs = new List();
    }
    List<WorkMenu> menus = widget.workPlan.menus;
    List<ListForSetSelect> _list = new List();
    menus.forEach((menu) {
      _list.add(menu);
      // TODO ワークアウト履歴があればそれを、なければ直近のデータを表示する
      WorkLog log = new WorkLog();
      existLogs.forEach((l) {
        if (l.menuCode == menu.code) {
          log = l;
        }
      });
      if (log.logs.length == 0) {
        _list.addAll(WorkoutSet.getDefaultLogs());
      } else {
        _list.addAll(WorkoutSet.translateFromMap(log.logs));
      }
      _list.add(new AddNewSet());
      _list.add(new Separator());
    });
    _list.add(new AddNewMenu());
    return _list;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.workPlan.nameJa),
      actions: <Widget>[
        FlatButton(
            child: Text('完了',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () {
              saveLogs();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(user: widget.user)));
            })
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: WorkLogDao.getLogByUserAndDate(widget.user.uid, widget.date),
      builder: (context, snapshot) {
        return _buildList(context, snapshot);
      },
    );
  }

  Widget _buildList(BuildContext context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return CircularLoad();
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _displayList.length,
        itemBuilder: (context, int index) {
          final item = _displayList[index];
          final bool alreadySaved = _done.contains(item);
          if (item is WorkMenu) {
            return ListTile(
              title: Text(
                item.nameJa,
                style: Theme.of(context).textTheme.headline,
              ),
              trailing: Icon(
                alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
                color: alreadySaved ? Colors.blue : null,
              ),
              onTap: () {
                setState(() {
                  if (alreadySaved) {
                    _done.remove(item);
                  } else {
                    _done.add(item);
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
                  if (_displayList.contains(item)) {
                    setState(() {
                      _displayList.remove(item);
                    });
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("削除しました")));
                  }
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(weight + weightUnit + reps + repsUnit),
                  onTap: () {
                    showPickerArray(context, _displayList.indexOf(item));
                  },
                ));
          } else if (item is Separator) {
            return Divider(color: Colors.black38);
          } else if (item is AddNewSet) {
            return ListTile(
                title: Text("セットを追加"),
                onTap: () => {
                      setState(() {
                        _displayList.insert(
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
    WorkoutSet rowData = _displayList[indexOfList];
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData2), isArray: true),
        hideHeader: true,
        title: Text("結果を入力"),
        // 初期値
        selecteds: [
          getWeightForPicker(rowData.weight),
          0,
          rowData.reps.toInt(),
          0
        ],
        onConfirm: (Picker picker, List value) {
          setState(() {
            List<String> selectedVals = picker.getSelectedValues();
            double weightUnit = selectedVals[1] == 'kg' ? 0 : 1;
            _displayList[indexOfList] = WorkoutSet.newData(
                double.parse(selectedVals[0]),
                weightUnit,
                int.parse(selectedVals[2]));
          });
        }).showDialog(context);
  }

  int getWeightForPicker(num weight) {
    if (weight <= 40) {
      return weight.round() - 1;
    }
    weight = weight - 40;
    int returnNum = (weight / 2.5).round();
    return returnNum + 39;
  }

  void saveLogs() {
    // This is O(n^2) but n will not be big. so it's acceptable.
    List<WorkLog> insertList = new List();
    List<WorkLog> updateList = new List();
    List<WorkLog> deleteList = new List();
    DateTime date =
        DateTime(widget.date.year, widget.date.month, widget.date.day);
    for (WorkMenu done in this._done) {
      WorkLog workLog = new WorkLog();
      List<Map<String, num>> results = new List();

      bool isDone = false;
      for (ListForSetSelect item in this._displayList) {
        if (item is WorkMenu && item.code == done.code) {
          workLog = WorkLog.createNewLog(
              widget.user.uid,
              done.code,
              done.nameJa,
              done.nameEn,
              [],
              Timestamp.fromDate(date),
              WorkType.of(done.workType));
          isDone = true;
          continue;
        }
        if (isDone == false) continue;
        if (item is WorkoutSet) {
          Map<String, num> map = {
            "reps": item.reps,
            "weight": item.weight,
            "weightUnit": item.weightUnit,
          };
          results.add(map);
          continue;
        }
        if (item is Separator) {
          workLog.logs = results;
          isDone = false;
        }
      }
      // TODO 今はいいけどlogの直近データ取る対応済んだらここの実装買えないと行けない
      bool isExist = false;
      _existLogs.forEach((l) {
        if (l.menuCode == workLog.menuCode) {
          l.logs = workLog.logs;
          if(l.logs.length==0){
            deleteList.add(l);
          }else{
            updateList.add(l);
          }
          isExist = true;
        }
      });
      if (isExist == false) {
        if(workLog.logs.length>0){
          insertList.add(workLog);
        }
      }
    }
    WorkLogDao.insertLogs(insertList);
    WorkLogDao.updateLogs(updateList);
    WorkLogDao.deleteLogs(deleteList);
  }
}
