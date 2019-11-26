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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override 
  void initState(){
    super.initState();
  }
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      body: _buildBody(context)

    );
  }
  Widget _buildAppBar(BuildContext context){
    return AppBar(title: Text("追加するメニューを選択"),);
  }
  Widget _buildBody(BuildContext context){
    return ListTile(
                title: Text("完了", textAlign: TextAlign.center),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkPlanCreatePage(
                            user: widget.user, date: widget.date),
                      ),
                    ));
  }
}