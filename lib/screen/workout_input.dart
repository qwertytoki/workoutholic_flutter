import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/workout_set.dart';
import 'package:workoutholic/dto/workout_menu.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:workoutholic/const/picker_data.dart';
import 'dart:convert';
import 'package:workoutholic/dto/work_menu.dart';

class WorkoutInputPage extends StatefulWidget {
  final WorkMenu workMenu;
  WorkoutInputPage({@required this.workMenu});

  @override
  _WorkoutInputPageState createState() => _WorkoutInputPageState();
}

class _WorkoutInputPageState extends State<WorkoutInputPage> {
  final items = List<String>.generate(5, (i) => "100 kg ${i + 1} 回");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.workMenu.nameJa),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("deleteする")));
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text('$item'),
                onTap: () {
                  showPicker(context);
                },
              ),
            );
          }),
    );
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData2)),
        changeToFirst: true,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        });
    picker.show(_scaffoldKey.currentState);
  }

  // Widget _buildBody(BuildContext context) {
  //   return ListView.builder(
  //     itemCount: items.length,
  //     itemBuilder: (context, index) {
  //       final item = items[index];
  //       return Dismissible(
  //         key: Key(item),
  //         onDismissed: (direction) {
  //           setState(() {
  //             items.removeAt(index);
  //           });
  //           Scaffold.of(context)
  //               .showSnackBar(SnackBar(content: Text("deleteする")));
  //         },
  //         background: Container(color: Colors.red),
  //         child: ListTile(
  //           title: Text('$item'),
  //           onTap: () {
  //             // showDialog(
  //             //       context: context,
  //             //       builder: (BuildContext context) {
  //             //         return AlertDialog(
  //             //           title: Text("test"),
  //             //         );
  //             //       }
  //             //   );
  //             //うまく動かない
  //             showPicker(context);
  //           },
  //         ),
  //       );
  //     },
  //   );

  // return StreamBuilder<QuerySnapshot>(
  //     stream: WorkoutMenu.getMenuFromWorkoutSet(_workoutSet.workoutIds),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return LinearProgressIndicator();
  //       return _buildList(context, snapshot.data.documents);
  //     });
}

// // for firebase
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
//       ),
//     ),
//   );
// }
