import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/latest_work_log.dart';
import 'package:workoutholic/dao/latest_work_log_dao.dart';
import 'package:workoutholic/dto/work_plan.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';
import 'package:workoutholic/const/list_for_set_select.dart';
import 'package:workoutholic/const/work_type.dart';
import 'package:workoutholic/dto/workout_set.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:workoutholic/const/picker_data.dart';
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:workoutholic/screen/home_page.dart';
import 'package:workoutholic/dto/user.dart';

class WorkoutMenuSelect extends StatefulWidget {
  final WorkPlan workPlan;
  final User user;
  final DateTime date;
  @override
  WorkoutMenuSelect(
      {@required this.user, @required this.date, @required this.workPlan});

  _WorkoutMenuSelectState createState() => _WorkoutMenuSelectState();
}

class _WorkoutMenuSelectState extends State<WorkoutMenuSelect> {
  final Set<WorkMenu> _done = Set<WorkMenu>();
  List<ListForSetSelect> _displayList = new List();
  List<WorkLog> _existLogs = new List();
  List<LatestWorkLog> _latestWorkLogs = new List();

  @override
  void initState() {
    super.initState();
    List<String> menuCodeList = new List();
    widget.workPlan.menus.forEach((m) {
      menuCodeList.add(m.code);
    });
    Future.wait([
      WorkLogDao.getLogByUserAndDate(widget.user.uid, widget.date),
      LatestWorkLogDao.getLogByCodes(menuCodeList)
    ]).then((values) {
      setState(() {
        _existLogs = values[0];
        _latestWorkLogs = values[1];
        _displayList = _generateDisplayList();
      });
    });
  }

  List<ListForSetSelect> _generateDisplayList() {
    List<WorkMenu> menus = new List();
    menus.addAll(widget.workPlan.menus);
    List<ListForSetSelect> _list = new List();
    menus.forEach((menu) {
      _list.add(menu);
      WorkLog log = new WorkLog();
      _existLogs.forEach((l) {
        if (l.menuCode == menu.code) {
          log = l;
        }
      });
      log.menuCode = menu.code;
      List<WorkoutSet> _logs = new List();
      if (log.logs.length == 0) {
        LatestWorkLog _latestLog = _getLatestFromMenuCode(log.menuCode);
        if (_latestLog == null) {
          _logs = WorkoutSet.getDefaultLogs();
        } else {
          _logs = WorkoutSet.translateFromMap(_latestLog.logs);
        }
      } else {
        _logs = WorkoutSet.translateFromMap(log.logs);
      }
      _logs.forEach((_l) {
        _l.menuCode = log.menuCode;
      });
      _list.addAll(_logs);
      _list.add(new AddNewSet());
      _list.add(new Separator());
    });
    _list.add(new AddNewMenu());
    return _list;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  LatestWorkLog _getLatestFromMenuCode(String menuCode) {
    for (LatestWorkLog _l in _latestWorkLogs) {
      if (_l.menuCode == menuCode) {
        return _l;
      }
    }
    return null;
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.workPlan.nameJa),
      actions: <Widget>[
        FlatButton(
            child: Text('完了',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () {
              _saveLogs();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(user: widget.user, date: widget.date)));
            })
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return _buildList(context);
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _displayList.length,
        itemBuilder: (context, index) {
          final item = _displayList[index];
          final bool alreadySaved = _done.contains(item);
          if (item is WorkMenu) {
            return ListTile(
              title: Text(
                item.nameJa,
                // style: Theme.of(context).textTheme.headline,
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
                      _addToDone(item.menuCode);
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
              onTap: () => setState(() {
                // this -1 is always SAFE.
                ListForSetSelect preItem = _displayList[index - 1];
                WorkoutSet set;
                if (preItem is WorkMenu) {
                  set = WorkoutSet.of(60, 0, 10, preItem.code);
                } else if (preItem is WorkoutSet) {
                  set = WorkoutSet.of(preItem.weight, preItem.weightUnit,
                      preItem.reps, preItem.menuCode);
                }
                _displayList.insert(index, set);
                _addToDone(set.menuCode);
              }),
            );
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
            _displayList[indexOfList] = WorkoutSet.of(
                double.parse(selectedVals[0]),
                weightUnit,
                int.parse(selectedVals[2]),
                rowData.menuCode);
            _addToDone(rowData.menuCode);
          });
        }).showDialog(context);
  }

  void _addToDone(String menuCode) {
    for (ListForSetSelect l in _displayList) {
      if (l is WorkMenu) {
        if (l.code == menuCode) {
          _done.add(l);
          break;
        }
      }
    }
  }

  int getWeightForPicker(num weight) {
    if (weight <= 40) {
      return weight.round() - 1;
    }
    weight = weight - 40;
    int returnNum = (weight / 2.5).round();
    return returnNum + 39;
  }

  void _saveLogs() {
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
              widget.workPlan.code,
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
      bool isExist = false;
      _existLogs.forEach((l) {
        if (l.menuCode == workLog.menuCode) {
          l.logs = workLog.logs;
          if (l.logs.length == 0) {
            deleteList.add(l);
          } else {
            updateList.add(l);
          }
          isExist = true;
        }
      });
      if (isExist == false) {
        if (workLog.logs.length > 0) {
          insertList.add(workLog);
        }
      }
    }
    _addToLatestLog(insertList, updateList);
    WorkLogDao.insertLogs(insertList);
    WorkLogDao.updateLogs(updateList);
    WorkLogDao.deleteLogs(deleteList);
  }

  _addToLatestLog(List<WorkLog> insertList, List<WorkLog> updateList) {
    List<WorkLog> logList = new List();
    logList.addAll(insertList);
    logList.addAll(updateList);
    List<LatestWorkLog> latestInsert = new List();
    List<LatestWorkLog> latestUpdate = new List();
    logList.forEach((log) {
      bool isNew = true;
      LatestWorkLog newLatestLog = LatestWorkLog.translateFromLog(log);
      for (LatestWorkLog preLatestLog in _latestWorkLogs) {
        if (newLatestLog.menuCode == preLatestLog.menuCode) {
          newLatestLog.documentID = preLatestLog.documentID;
          latestUpdate.add(newLatestLog);
          isNew = false;
        }
      }
      if (isNew) {
        latestInsert.add(newLatestLog);
      }
    });

    LatestWorkLogDao.insertLogs(latestInsert);
    LatestWorkLogDao.updateLogs(latestUpdate);
  }
}
