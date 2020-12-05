import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/components/Providers.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';
import 'package:yetanothertimerapp/components/TimerItem.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    print("building Dashboard widget");
    final newTimerController = TextEditingController();

    return Scaffold(
      body: Column(children: [
        Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [
              const TitleBar(),
              TextField(
                key: UniqueKey(),
                controller: newTimerController,
                decoration: const InputDecoration(
                  labelText: 'How long to set new timer?',
                ),
                onSubmitted: (value) {
                  context
                      .read(timerListProvider)
                      .add(UniqueKey(), int.parse(value));
                  newTimerController.clear();
                },
              ),
              const SizedBox(height: 30),
              const Toolbar(),
              const SizedBox(height: 20),
            ])),
        Container(
          padding: EdgeInsets.all(20.0),
          child: const TimerListWidget(),
        ),
      ]),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("building TitleBar widget");
    return const Text(
      'timers',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetiica Neue',
      ),
    );
  }
}

class Toolbar extends ConsumerWidget {
  const Toolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print("building Toolbar widget");
    final Map<UniqueKey, TimerNotifier> allTimersList =
        watch(timerListProvider).timerMap;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${allTimersList.length.toString()} timers running',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class TimerListWidget extends ConsumerWidget {
  const TimerListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final Map<UniqueKey, TimerNotifier> allTimersList =
        watch(timerListProvider).timerMap;
    print("building TimerListWidget with $allTimersList");

    return GridView.extent(
        shrinkWrap: true,
        primary: false,
        maxCrossAxisExtent: 220,
        children: allTimersList.entries.map((t) {
          return Dismissible(
            key: ValueKey(t.key),
            onDismissed: (_) {
              context.read(timerListProvider).remove(t.key);
              print("removed ${t.key}");
            },
            child: TimerItem(t.key),
          );
        }).toList());
  }
}
