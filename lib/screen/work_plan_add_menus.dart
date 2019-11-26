import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/screen/work_plan_create.dart';
import 'package:workoutholic/dto/work_menu.dart';

class WorkPlanAddMenuPage extends StatefulWidget{
  final User user;
  final DateTime date;
  final List<WorkMenu> menus;

  @override
  WorkPlanAddMenuPage({@required this.user,@required this.date,@required this.menus});
  _WorkPlanAddMenuState createState() => _WorkPlanAddMenuState();
}

class _WorkPlanAddMenuState extends State<WorkPlanAddMenuPage>{

}