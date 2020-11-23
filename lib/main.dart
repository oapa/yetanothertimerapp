import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/screens/Home.dart';

void main() {
  runApp(YetAnotherTimerApp());
}

class YetAnotherTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yet Another Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: YATAHomePage(title: 'Timers Dashboard'),
    );
  }
}
