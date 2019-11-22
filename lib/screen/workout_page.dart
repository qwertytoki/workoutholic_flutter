import 'dart:async';
import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutholic/screen/workout_plan_select.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';

class WorkoutPage extends StatefulWidget {
  final User user;
  WorkoutPage({@required this.user});
  @override
  _MyWorkoutPageState createState() => _MyWorkoutPageState();
}

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class _MyWorkoutPageState extends State<WorkoutPage>
    with TickerProviderStateMixin {
  _MyWorkoutPageState();
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedDay = new DateTime(now.year, now.month, now.day);
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    // Future戻してあげる
    _getWorkLog(_selectedDay).then((monthlyLogsMap) {
      setState(() {
        _events = monthlyLogsMap;
        _selectedEvents = _events[_selectedDay] ?? [];
        _visibleEvents = _events;
        _visibleHolidays = _holidays;
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  Future<Map<DateTime, List<String>>> _getWorkLog(DateTime date) async {
    // TODO 何Kg何Repあげれたのかも今後表示したい。(今回は対応しない。)

    Map<DateTime, List<String>> map = new Map();
    List<WorkLog> logs = await WorkLogDao.getLogByMonth(date);
    logs.forEach((l) {
      DateTime dt = new DateTime.fromMicrosecondsSinceEpoch(
          l.date.microsecondsSinceEpoch);
      if (map.containsKey(dt)) {
        List<String> list = map[dt];
        list.add(l.menuNameJa);
      } else {
        List<String> list = new List();
        list.add(l.menuNameJa);
        map.putIfAbsent(dt, () => list);
      }
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToSetSelect();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void moveToSetSelect() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              WorkoutPlanSelectPage(user: widget.user, date: _selectedDay)),
    );
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    _getWorkLog(first).then((monthlyLogsMap) {
      setState(() {
        _events.addAll(monthlyLogsMap);
        _selectedEvents = _events[_selectedDay] ?? [];
        _visibleEvents = _events;
        _visibleEvents = Map.fromEntries(
          _events.entries.where(
            (entry) =>
                entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
                entry.key.isBefore(last.add(const Duration(days: 1))),
          ),
        );

        _visibleHolidays = Map.fromEntries(
          _holidays.entries.where(
            (entry) =>
                entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
                entry.key.isBefore(last.add(const Duration(days: 1))),
          ),
        );
      });
    });
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events != null) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Utils.isSameDay(date, _selectedDay)
            ? Colors.brown[500]
            : Utils.isSameDay(date, DateTime.now())
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => moveToMenu(_selectedDay),
                ),
              ))
          .toList(),
    );
  }

  void moveToMenu(DateTime _date) {
    // TODO 入力画面に遷移する
    // TODO 右下のフローター選択時、すでに今日にログがある場合はset選択させずに直接入力画面に遷移する
    // TODO そのメニューにフォーカスが移って、フラッシュさせたい
    
  }
}
