import 'package:workoutholic/screen/workoutSetSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekDay;

class Calendar extends StatefulWidget {
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Calendar> {
  DateTime _currentDate = DateTime.now();
  Map<DateTime, int> _markedDateMap = {
    //TODO ここでワークアウトの数だけマークつけたい
    DateTime(2018, 9, 20) : 4,
    DateTime(2018, 10, 11) : 1,
    DateTime(2018, 12, 10) : 2,
    DateTime(2019, 1, 10) : 3,
  };

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Workout Result"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.today), onPressed: _goToday ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel(
          onDayPressed: (DateTime date) {
            this.setState(() => _currentDate = date);
          },
          weekendTextStyle: TextStyle(
            color: Colors.red,
          ),
          thisMonthDayBorderColor: Colors.grey,
          weekFormat: false,
          weekends: [WeekDay.Sunday, WeekDay.Saturday],
          markedDatesMap: _markedDateMap,
          height: 420.0,
          selectedDateTime: _currentDate,
          daysHaveCircularBorder: null, /// null for not rendering any border, true for circular border, false for rectangular border
        ),
      ), 
      floatingActionButton: FloatingActionButton(
        onPressed: _goInputPage,
         tooltip: 'Increment',
        child: Icon(Icons.add),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _goToday(){
    this.setState(() => _currentDate = new DateTime.now());
  }

  void _goInputPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutSetSelect(selectedDate :_currentDate)),
    );
  }   
}