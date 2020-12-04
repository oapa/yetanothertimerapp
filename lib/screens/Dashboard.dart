import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/components/TimerList.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

final timerListProvider = ChangeNotifierProvider<TimerMap>((ref) {
  UniqueKey timer1Key = UniqueKey();
  UniqueKey timer2Key = UniqueKey();
  return TimerMap({
    timer1Key: TimerNotifier(timer1Key, 10, TimerState.initial),
    timer2Key: TimerNotifier(timer2Key, 13, TimerState.initial)
  });
});

// final _timerListProvider = StateNotifierProvider<TimerList>((ref) {
//   UniqueKey timer1Key = UniqueKey();
//   UniqueKey timer2Key = UniqueKey();
//   return TimerList([
//     TimerNotifier(timer1Key, 10, TimerState.initial),
//     TimerNotifier(timer2Key, 13, TimerState.initial)
//   ]);
// });

// final timerListProvider = ChangeNotifierProvider<TimerList>((ref) {
//   UniqueKey timer1Key = UniqueKey();
//   UniqueKey timer2Key = UniqueKey();
//   return TimerList([
//     TimerNotifier(timer1Key, 10, TimerState.initial),
//     TimerNotifier(timer2Key, 13, TimerState.initial)
//   ]);
// });

// final timerListProvider = ChangeNotifierProvider<TimerList>((ref) {
//   return ref.watch(_timerListProvider);
// });

// final _allTimers = Provider<List<TimerNotifier>>((ref) {
//   return ref.watch(timerListProvider).timerList;
// });

// final allTimers = Provider<List<TimerNotifier>>((ref) {
//   return ref.watch(_allTimers);
// });

// final _timerNotifierProvider =
//     StateNotifierProvider.family<TimerNotifier, UniqueKey>((ref, id) {
//   return ref.watch(allTimers).where((t) => t.id == id).first;
// });

final _allTimers = Provider<Map<UniqueKey, TimerNotifier>>((ref) {
  return ref.watch(timerListProvider).timerMap;
});

final allTimers = Provider<Map<UniqueKey, TimerNotifier>>((ref) {
  return ref.watch(_allTimers);
});

final _timerNotifierProvider =
    StateNotifierProvider.family<TimerNotifier, UniqueKey>((ref, id) {
  return ref.watch(allTimers)[id];
});

final timerNotifierProvider =
    StateNotifierProvider.family<TimerNotifier, UniqueKey>((ref, id) {
  return ref.watch(_timerNotifierProvider(id));
});

final _timeRemainingProvider = Provider.family<int, UniqueKey>((ref, id) {
  return ref.watch(timerNotifierProvider(id).state).timeRemaining;
});

final timeRemainingProvider = Provider.family<int, UniqueKey>((ref, id) {
  return ref.watch(_timeRemainingProvider(id));
});

final _timerStateProvider = Provider.family<TimerState, UniqueKey>((ref, id) {
  return ref.watch(timerNotifierProvider(id).state).timerState;
});

final timerStateProvider = Provider.family<TimerState, UniqueKey>((ref, id) {
  return ref.watch(_timerStateProvider(id));
});

class TitleBar extends StatelessWidget {
  const TitleBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'timers',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetiica Neue',
      ),
    );
  }
}

class Dashboard extends ConsumerWidget {
  const Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final List<TimerNotifier> allTimersList =
    //     watch(timerListProvider).timerList;
    final Map<UniqueKey, TimerNotifier> allTimersList =
        watch(timerListProvider).timerMap;
    final newTimerController = TextEditingController();

    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${allTimersList.length.toString()} timers running',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            ...allTimersList.entries.map((t) {
              return Dismissible(
                key: ValueKey(t.key),
                onDismissed: (_) {
                  context.read(timerListProvider).remove(t.key);
                  print("removed ${t.key}");
                  print("all timers is now $allTimers");
                },
                child: TimerItem(t.key),
              );
            }).toList(),
            // for (var i = 0; i < allTimersList.length; i++) ...[
            //   Dismissible(
            //     key: ValueKey(allTimersList[i].id),
            //     onDismissed: (_) {
            //       context.read(timerListProvider).remove(allTimersList[i].id);
            //     },
            //     child: TimerItem(allTimersList[i].id),
            //   )
            // ]
          ]),
    );
  }
}

// class Toolbar extends ConsumerWidget {
//   const Toolbar({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     // Map<UniqueKey, TimerNotifier> timerMap = watch(timerListProvider.state);
//     // Map<UniqueKey, TimerNotifier> timerMap = watch(timerListProvider).timerMap;
//     List<TimerNotifier> = watch(timerListProvider);
//     // List<TimerItem> timerList =
//     //     timerMap.entries.map((e) => TimerItem(key: e.key)).toList();
//     print("timerList is $timerMap");

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             '${timerMap.length.toString()} timers running',
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//     // return Column(children: timerList);
//   }
// }

// class TimerListWidget extends ConsumerWidget {
//   const TimerListWidget({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     // Map<UniqueKey, TimerNotifier> timerMap =
//     //     context.read(timerListProvider).timerMap;
//     List<TimerItem> timerList =
//         watch(allTimers).entries.map((e) => TimerItem(key: e.key)).toList();
//     print("allTimers is currently $allTimers");
//     return Column(children: timerList);
//   }
// }

class TimerItem extends ConsumerWidget {
  final UniqueKey id;
  TimerItem(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerNotifier timer = watch(timerNotifierProvider(id));
    int timeRemaining = watch(timeRemainingProvider(id));
    TimerState timerState = watch(timerStateProvider(id));
    print("$timeRemaining timeRemaining for $id");
    print("$timerState timerState for $id");

    print('building TimerTextWidget $timeRemaining');
    return Row(children: [
      // TimerButtonsContainer(uniqueKey: key, timerState: timerState),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (timerState == TimerState.initial) ...[
          FloatingActionButton(
            onPressed: () {
              timer.startTimer();
            },
            child: Icon(Icons.play_arrow),
          ),
        ],
        if (timerState == TimerState.started) ...[
          FloatingActionButton(
            onPressed: () {
              timer.pauseTimer();
            },
            child: Icon(Icons.pause),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              timer.resetTimer();
            },
            child: Icon(Icons.replay),
          ),
        ],
        if (timerState == TimerState.paused) ...[
          FloatingActionButton(
            onPressed: () {
              timer.startTimer();
            },
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              timer.resetTimer();
            },
            child: Icon(Icons.replay),
          ),
        ],
        if (timerState == TimerState.finished) ...[
          FloatingActionButton(
            onPressed: () {
              timer.resetTimer();
            },
            child: Icon(Icons.replay),
          ),
        ],
        SizedBox(
          width: 20,
        ),
        // Consumer(builder: (context, watch, child) {
        //   String timeRemaining =
        //       watch(_currentTimerModel).timeRemaining.toString();
        //   return
        Text(
          '$timeRemaining',
          style: Theme.of(context).textTheme.headline2,
        )
        // ;
        // })
        ,
      ])
    ]);
  }
}

// class StartButton extends StatelessWidget {
//   const StartButton({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         context.read(_currentTimer).startTimer();
//       },
//       child: Icon(Icons.play_arrow),
//     );
//   }
// }

// class PauseButton extends StatelessWidget {
//   const PauseButton({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         context.read(_currentTimer).pauseTimer();
//       },
//       child: Icon(Icons.pause),
//     );
//   }
// }

// class ResetButton extends StatelessWidget {
//   const ResetButton({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         context.read(_currentTimer).resetTimer();
//       },
//       child: Icon(Icons.replay),
//     );
//   }
// }
