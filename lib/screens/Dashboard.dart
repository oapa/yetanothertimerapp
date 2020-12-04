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

class Dashboard extends StatelessWidget {
  const Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    print("building Dashboard widget");
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
            const Toolbar(),
            const SizedBox(height: 20),
            const TimerListWidget(),
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

    return Column(
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

class TimerItem extends ConsumerWidget {
  final UniqueKey id;
  TimerItem(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerNotifier timer = watch(timerNotifierProvider(id));
    int timeRemaining = watch(timeRemainingProvider(id));
    TimerState timerState = watch(timerStateProvider(id));
    // print("$timeRemaining timeRemaining for $id");
    // print("$timerState timerState for $id");

    print(
        'building $id TimerTextWidget: $timerState, ${timeRemaining}s remaining');
    return Row(children: [
      // TimerButtonsContainer(timerState),
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
        Text(
          '$timeRemaining',
          style: Theme.of(context).textTheme.headline2,
        ),
      ])
    ]);
  }
}

class TimerButtonsContainer extends ConsumerWidget {
  final UniqueKey id;
  TimerButtonsContainer(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerNotifier timer = watch(timerNotifierProvider(id));
    int timeRemaining = watch(timeRemainingProvider(id));
    TimerState timerState = watch(timerStateProvider(id));
    print("$timeRemaining timeRemaining for $id");
    print("$timerState timerState for $id");

    print('building TimerTextWidget $timeRemaining');
    return Row(children: [
      // TimerButtonsContainer(timerState),
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
        Text(
          '$timeRemaining',
          style: Theme.of(context).textTheme.headline2,
        ),
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
