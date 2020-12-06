import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/components/QuickAddTimer.dart';
import 'package:yetanothertimerapp/components/SummaryBar.dart';
import 'package:yetanothertimerapp/components/TimerGroup.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    print("building Dashboard widget");

    return Scaffold(
      appBar: AppBar(
        title: Text("Timer App"),
      ),
      body: CustomScrollView(slivers: <Widget>[
        const QuickAddTimer(),
        const SummaryBar(),
        ...TimerGroup().getTimerGroup(),
      ]),
    );
  }
}
