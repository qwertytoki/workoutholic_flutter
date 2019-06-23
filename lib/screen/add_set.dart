import 'package:flutter/material.dart';

class AddSetPage extends StatefulWidget {
    // final WorkoutSet workey key, @required this.workoutSetoutSet;
    // WorkoutInputPage({K}) : super(key: key);
    @override
    _AddSetPageState createState() => _AddSetPageState();
  }
  class _AddSetPageState extends State<AddSetPage>{

  Widget build(BuildContext context) {
    final TextEditingController setNameController = TextEditingController();
    Scaffold scaffold = new Scaffold(
      appBar: AppBar(
        title: Text("Create New Set"),
        ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                hintText: "Type your set name.",
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
                          child: Text("Add"),
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
  void _saveSet(){
    print("add");
  }
}
