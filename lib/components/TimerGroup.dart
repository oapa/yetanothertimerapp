import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/Constructors.dart';
import 'package:yetanothertimerapp/shared/UISettings.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';
import 'package:yetanothertimerapp/components/TimerItem.dart';

List<Widget> getTimerGroup(String groupName) {
  return [
    TimerListHeader(groupName: groupName),
    TimerListWidget(groupName: groupName)
  ];
}

class TimerListHeader extends StatelessWidget {
  final String groupName;
  const TimerListHeader({Key key, @required this.groupName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 30.0,
        maxHeight: 30.0,
        child: Container(
            color: Colors.blue, child: Center(child: Text("$groupName"))),
      ),
    );
  }
}

class TimerListWidget extends ConsumerWidget {
  final String groupName;
  const TimerListWidget({Key key, @required this.groupName}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final Map<UniqueKey, TimerNotifier> allTimersList =
        watch(timerListProvider).timerMap;
    print("building TimerListWidget with $allTimersList");

    return SliverPadding(
        padding: EdgeInsets.all(timerGroupPadding),
        sliver: SliverGrid.count(
            mainAxisSpacing: timerGridSpacing,
            crossAxisSpacing: timerGridSpacing,
            crossAxisCount:
                (MediaQuery.of(context).size.width / maxTimerItemSize).round(),
            // childAspectRatio: MediaQuery.of(context).size.width /
            //     (MediaQuery.of(context).size.height / 2),
            children: allTimersList.entries.map((t) {
              return Dismissible(
                key: ValueKey(t.key),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) {
                  context.read(timerListProvider).remove(t.key);
                  print("removed ${t.key}");
                },
                child: TimerItem(t.key),
              );
            }).toList()));
  }
}
