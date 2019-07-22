import 'package:flutter/material.dart';
import 'package:workoutholic/screen/workout_page.dart';
import 'package:workoutholic/screen/transition_page.dart';
import 'package:workoutholic/screen/profile_page.dart';
import 'package:workoutholic/dto/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  @override
  HomePage({@required this.user});

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController _pageController;
  int _page = 0;

  void onNavigationTapped(int page) {
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
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
    return Scaffold(
      body: PageView(
        children: <Widget>[
          new WorkoutPage(),
          new TransitionPage(),
          new ProfilePage(),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            title: new Text("Workout"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.trending_up),
            title: new Text("Transition"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
          ),
        ],
        onTap: onNavigationTapped,
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
