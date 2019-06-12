import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutholic/dto/workout_set.dart';
import 'package:workoutholic/screen/workout_menu_select.dart';
import 'package:workoutholic/dto/work_set.dart';
import 'package:workoutholic/dao/work_set_dao.dart';

class WorkoutSetSelectPage extends StatelessWidget {
  @override
  // final DateTime selectedDate;
  // WorkoutSetSelect({Key key, @required this.selectedDate}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Workout Set"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    const data = [
      'Big 3',
      'Legs',
      'Chest and Triceps',
      'Back and Biceps',
      'Abs'
    ];
    List<WorkSet> workSets = WorkSetDao.genarateMockData();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),  
      itemCount: data.length,
      itemBuilder: (context, int index) {
      if (index.isOdd) return Divider(); 
      return ListTile(
        title: Text(
          data[index],
          style: const TextStyle(fontSize: 18.0),
        ),
        onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WorkoutMenuSelect()),
              ),
        );
        }
      );
  }
  List<WorkSet> genrateMockData(){
    List<WorkSet> workSets = new List();  
    workSets.add(WorkSet.createNewSet("id1", "", "Big3", "Big3", "The day condition is perfect", null, true));
    workSets.add(WorkSet.createNewSet("id2", "", "Chest Day", "胸の日", "Every Wednesday", null, true));
    workSets.add(WorkSet.createNewSet("id3", "", "Legs Day", "脚の日", "Every Monday", null, true));
    return workSets;
  }

// firebase使うなら以下のソース
  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection('workoutSet').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return LinearProgressIndicator();
  //       return _buildList(context, snapshot.data.documents);
  //     },
  //   );
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
  //     padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: ListTile(
  //         title: Text(workoutSet.setName),
  //         // trailing: Text(record.votes.toString()),
  //         onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) =>
  //                       WorkoutMenuSelect(workoutSet: workoutSet)),
  //             ),
  //       ),
  //     ),
  //   );
  // }
}
