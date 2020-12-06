import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/Constructors.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class SummaryBar extends ConsumerWidget {
  const SummaryBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print("building Toolbar widget");
    final Map<UniqueKey, TimerNotifier> allTimersList =
        watch(timerListProvider).timerMap;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: Container(
            color: Colors.lightGreen,
            child: Center(
              child: Text(
                '${allTimersList.length.toString()} timers running',
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ),
    );
  }
}
