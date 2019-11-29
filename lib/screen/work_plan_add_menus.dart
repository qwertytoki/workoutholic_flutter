import 'package:flutter/material.dart';
import 'package:workoutholic/dto/user.dart';
import 'package:workoutholic/dto/work_menu.dart';
import 'package:workoutholic/dao/work_menu_dao.dart';

class WorkPlanAddMenusPage extends StatefulWidget {
  final User user;
  final DateTime date;
  final List<WorkMenu> selectedMenus;

  @override
  WorkPlanAddMenusPage(
      {@required this.user, @required this.date, this.selectedMenus});
  _WorkPlanAddMenusState createState() => _WorkPlanAddMenusState();
}

class _WorkPlanAddMenusState extends State<WorkPlanAddMenusPage> {
  Set<WorkMenu> _addList = new Set();
  List<WorkMenu> _allMenus = new List();
  @override
  void initState() {
    super.initState();
    widget.selectedMenus.forEach((m) {
      _addList.add(m);
    });
    WorkMenuDao.getAllMenus().then((menus) {
      setState(() {
        _allMenus = menus;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("追加するメニューを選択"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(_addList);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _allMenus.length,
        itemBuilder: (context, index) {
          WorkMenu menu = _allMenus[index];
          bool alreadySaved = false;
          for (WorkMenu m in _addList) {
            if (m.code == menu.code) {
              alreadySaved = true;
            }
          }

          return ListTile(
              title: Text(menu.nameJa),
              leading: Icon(
                alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
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
  }
}
