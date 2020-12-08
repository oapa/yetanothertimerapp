import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/components/CreateTimer.dart';
// import 'package:yetanothertimerapp/components/SummaryBar.dart';
import 'package:yetanothertimerapp/components/TimerGroup.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    print("building Dashboard widget");

    return Scaffold(
      appBar: AppBar(
        title: Text("Yet Another Timer App"),
      ),
      body: CustomScrollView(slivers: <Widget>[
        // QuickAddTimerSliver(),
        // const SummaryBar(),
        ...TimerGroup('Default').getTimerGroup(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateTimerDialog();
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
