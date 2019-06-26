import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/workout_set.dart';
import 'package:workoutholic/dto/workout_menu.dart';

class WorkoutInputPage extends StatefulWidget {
  WorkoutInputPage({Key key}) : super(key: key);

  @override
  _WorkoutInputPageState createState() => _WorkoutInputPageState();
}

class _WorkoutInputPageState extends State<WorkoutInputPage> {
  final items = List<String>.generate(5, (i) => "100 kg ${i} 回");
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ベンチプレス"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
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
          child: ListTile(title: Text('$item')),
        );
      },
    );

    // return StreamBuilder<QuerySnapshot>(
    //     stream: WorkoutMenu.getMenuFromWorkoutSet(_workoutSet.workoutIds),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) return LinearProgressIndicator();
    //       return _buildList(context, snapshot.data.documents);
    //     });
  }

  // for firebase
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final workoutSet = WorkoutSet.fromSnapshot(data);
    return Padding(
      key: ValueKey(workoutSet.setName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(workoutSet.setName),
          // trailing: Text(record.votes.toString()),
          // onTap: () => Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => WorkoutMenuSelect(workoutSet:workoutSet)),
          // ),
        ),
      ),
    );
  }
}
