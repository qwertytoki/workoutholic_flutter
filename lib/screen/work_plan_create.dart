import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/screen/workout_plan_select.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkPlanCreatePage extends StatelessWidget {
  final User user;
  final DateTime date;
  final List<WorkMenu> menus;
  @override
  WorkPlanCreatePage({@required this.user, @required this.date, this.menus});

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新しいプランを作成"),
          actions: <Widget>[
            FlatButton(
                child: Text('完了',
                    style: TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: () {
                  _saveLogs();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutPlanSelectPage(
                              user: this.user, date: this.date)));
                })
          ],
        ),
        body: ListView(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: new InputDecoration(hintText: "プラン名"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  ListTile(
                      title: Text("メニューを追加", textAlign: TextAlign.center),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutPlanSelectPage(
                                  user: this.user, date: this.date))))
                ],
              )),
        ]));
  }
}

_saveLogs() {
  // planテーブルに登録
}



// class _WorkPlanCreatePageState extends State<WorkPlanCreatePage> {
//   Widget build(BuildContext context) {
//     final TextEditingController setNameController = TextEditingController();
//     Scaffold scaffold = new Scaffold(
//       appBar: AppBar(
//         title: Text("新しいプランを作成"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: new InputDecoration(
//                 hintText: "プラン名",
//                 // labelText: Texts.get(TextKey.AP_NUMBER_LABEL),
//               ),
//               controller: setNameController,
//               // inputFormatters: [new UserNumberTextFormatter()],
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: 16.0,
//                 bottom: 32.0,
//               ),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: new Builder(
//                       builder: (BuildContext context) {
//                         return OutlineButton(
//                           child: Text("完了"),
//                           onPressed: () => _saveSet(),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 bottom: 16.0,
//               ),
//               child: Row(
//                 children: <Widget>[
//                   // Text(Texts.get(TextKey.AP_MEMBERS_LABEL)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//     return scaffold;
//   }

//   void _saveSet() {
//     print("add");
//   }
// }
