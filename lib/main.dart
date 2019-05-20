//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutholic/auth.dart';
import 'package:workoutholic/root_page.dart';



void main() {
  // runApp(new MyApp());
  //これ何してるんだろう
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Table Calendar Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth())
        // home: MyHomePage(title: 'Table Calendar Demo'),
      );
    }
}
