import 'package:flutter/material.dart';

class WorkPlanCreatePage extends StatefulWidget {
  // final WorkoutPlan workey key, @required this.workoutPlanoutSet;
  // WorkoutInputPage({K}) : super(key: key);
  @override
  _WorkPlanCreatePageState createState() => _WorkPlanCreatePageState();
}

class _WorkPlanCreatePageState extends State<WorkPlanCreatePage> {
  Widget build(BuildContext context) {
    final TextEditingController setNameController = TextEditingController();
    Scaffold scaffold = new Scaffold(
      appBar: AppBar(
        title: Text("新しいプランを作成"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                hintText: "プラン名",
                // labelText: Texts.get(TextKey.AP_NUMBER_LABEL),
              ),
              controller: setNameController,
              // inputFormatters: [new UserNumberTextFormatter()],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: 32.0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new Builder(
                      builder: (BuildContext context) {
                        return OutlineButton(
                          child: Text("完了"),
                          onPressed: () => _saveSet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Row(
                children: <Widget>[
                  // Text(Texts.get(TextKey.AP_MEMBERS_LABEL)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // this WillPopScope is not needed...? #105
    return scaffold;
  }

  void _saveSet() {
    print("add");
  }
}
