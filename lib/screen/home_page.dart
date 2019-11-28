import 'package:flutter/material.dart';
import 'package:workoutholic/screen/workout_page.dart';
import 'package:workoutholic/screen/transition_page.dart';
import 'package:workoutholic/screen/profile_page.dart';
import 'package:workoutholic/dto/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  final DateTime date;
  @override
  HomePage({@required this.user, this.date});
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController _pageController;
  int _page = 0;

  void onNavigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    print(widget.user.displayName);
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      body: PageView(
        children: <Widget>[
          new WorkoutPage(user: user, date: widget.date),
          // new TransitionPage(user: user),
          new ProfilePage(user: user),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            title: new Text("ワークアウト"),
          ),
          // new BottomNavigationBarItem(
          //   icon: new Icon(Icons.trending_up),
          //   title: new Text("進捗グラフ"),
          // ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("プロフィール"),
          ),
        ],
        onTap: onNavigationTapped,
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
