import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutholic/screen/workout_plan_select.dart';
import 'package:workoutholic/screen/workout_menu_select.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dto/work_log.dart';
import 'package:workoutholic/dao/work_log_dao.dart';
import 'package:workoutholic/dto/work_plan.dart';
import 'package:workoutholic/dao/work_plan_dao.dart';

class WorkoutPage extends StatefulWidget {
  final User user;
  final DateTime date;
  WorkoutPage({@required this.user, this.date});
  @override
  _MyWorkoutPageState createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<WorkoutPage>
    with TickerProviderStateMixin {
  _MyWorkoutPageState();
  DateTime _selectedDay;

  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List<WorkPlan> _plans = new List();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _calendarController = CalendarController();
    _selectedDay = new DateTime(now.year, now.month, now.day);
    // https://github.com/qwertytoki/workoutholic_flutter/issues/41
    // if (widget.date == null) {
    //   DateTime now = DateTime.now();
    //   _selectedDay = new DateTime(now.year, now.month, now.day);
    // } else {
    //   _selectedDay =
    //       new DateTime(widget.date.year, widget.date.month, widget.date.day);
    // }
    _events = {};
    _selectedEvents = [];
    _visibleEvents = {};

    Future.wait(
            [_getWorkLog(_selectedDay), WorkPlanDao.getPlans(widget.user.uid)])
        .then((values) {
      setState(() {
        _events = values[0];
        _selectedEvents = _events[_selectedDay] ?? [];
        _visibleEvents = _events;
        _plans = values[1];
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<Map<DateTime, List<WorkLog>>> _getWorkLog(DateTime date) async {
    Map<DateTime, List<WorkLog>> map = new Map();
    List<WorkLog> logs = await WorkLogDao.getLogByMonth(date);
    logs.forEach((l) {
      DateTime dt = new DateTime.fromMicrosecondsSinceEpoch(
          l.date.microsecondsSinceEpoch);
      if (map.containsKey(dt)) {
        List<WorkLog> list = map[dt];
        list.add(l);
      } else {
        List<WorkLog> list = new List();
        list.add(l);
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
          if (_selectedEvents.length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutMenuSelect(
                      user: widget.user,
                      workPlan: _getPlan(_selectedEvents[0].planCode),
                      date: _selectedDay)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutPlanSelectPage(
                      user: widget.user, date: _selectedDay)),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onDaySelected(DateTime day, List event) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = event;
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
      });
    });
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      events: _visibleEvents,
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
                    title: Text(event.menuNameJa),
                    subtitle: Text(_generateWorkSummary(event)),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutMenuSelect(
                                  user: widget.user,
                                  workPlan: _getPlan(event.planCode),
                                  date: _selectedDay)),
                        )),
              ))
          .toList(),
    );
  }

  String _generateWorkSummary(WorkLog workLog) {
    String sum = "";
    for (Map<String, num> l in workLog.logs) {
      sum += l["weight"].toString() + "kg×" + l["reps"].toString() + "  ";
      if (sum.length > 40){
        sum += "...";
        break;
      } 
    }
    return sum;
  }

  WorkPlan _getPlan(String planCode) {
    for (WorkPlan plan in _plans) {
      if (planCode == plan.code) {
        return plan;
      }
    }
    throw new Exception(
        "Plan is not exist. please check/ PlanCode:" + planCode);
  }
}
