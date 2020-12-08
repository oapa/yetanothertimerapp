import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/Constructors.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';
import 'package:yetanothertimerapp/components/TimerItem.dart';

class TimerGroup {
  final String groupName;
  const TimerGroup({this.groupName = 'Default'});

  List<Widget> getTimerGroup() {
    return [
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          minHeight: 30.0,
          maxHeight: 30.0,
          child: Container(
              color: Colors.blue, child: Center(child: Text("$groupName"))),
        ),
      ),
      TimerListWidget()
    ];
  }
}

class TimerListWidget extends ConsumerWidget {
  final String groupName;
  const TimerListWidget({Key key, this.groupName = 'Default'})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final Map<UniqueKey, TimerNotifier> allTimersList =
        watch(timerListProvider).timerMap;
    print("building TimerListWidget with $allTimersList");

    return SliverGrid.count(
        // mainAxisSpacing: 5,
        // crossAxisSpacing: 5,
        crossAxisCount: (MediaQuery.of(context).size.width / 375).round(),
        // childAspectRatio: MediaQuery.of(context).size.width /
        //     (MediaQuery.of(context).size.height / 2),
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
