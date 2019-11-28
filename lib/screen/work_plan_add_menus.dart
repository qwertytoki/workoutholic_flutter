import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/dao/work_menu_dao.dart';

class WorkPlanAddMenusPage extends StatefulWidget {
  final User user;
  final DateTime date;
  List<WorkMenu> displayMenus = new List();

  @override
  WorkPlanAddMenusPage(
      {@required this.user, @required this.date, this.displayMenus});
  _WorkPlanAddMenusState createState() => _WorkPlanAddMenusState();
}

class _WorkPlanAddMenusState extends State<WorkPlanAddMenusPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<WorkMenu> _addList = new List();
  List<WorkMenu> _allMenus = new List();
  @override
  void initState() {
    super.initState();
    WorkMenuDao.getAllMenus().then((menus) {
      setState(() {
        _allMenus = menus;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        body: _buildBody(context));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("追加するメニューを選択"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: WorkMenuDao.getAllMenus(),
      builder: (context, snapshot) {
        return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final datas = snapshot.data.documents;
              WorkMenu menu = WorkMenu.of(datas[index]);
              final bool alreadySaved = _addList.contains(menu);
              return ListTile(
                  title: Text(menu.nameJa),
                  leading: Icon(
                    alreadySaved
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: alreadySaved ? Colors.blue : null,
                  ),
                  onTap: () {
                    setState(() {
                      if (alreadySaved) {
                        _addList.remove(menu);
                      } else {
                        _addList.add(menu);
                      }
                    });
                  });
            });
      },
    );
  }
}
