import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yetanothertimerapp/components/TimerList.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

final timerListProvider = ChangeNotifierProvider<TimerMap>((ref) {
  UniqueKey timer1Key = UniqueKey();
  UniqueKey timer2Key = UniqueKey();
  return TimerMap({
    timer1Key: TimerNotifier(timer1Key, 20, TimerState.initial),
    timer2Key: TimerNotifier(timer2Key, 45, TimerState.initial)
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

class TimerItem extends StatelessWidget {
  final UniqueKey id;
  const TimerItem(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building $id TimerTextWidget');
    return
        // Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        TimerCircularAnimation(id)
        // ])
        ;
  }
}

class TimerCircularAnimation extends ConsumerWidget {
  final UniqueKey id;
  TimerCircularAnimation(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print("building TimerCircularWidget for $id");
    int initialDuration =
        context.read(timerNotifierProvider(id)).initialDuration;
    return Stack(children: [
      Container(
        width: 200,
        height: 200,
        child: Consumer(builder: (context, watch, child) {
          int timeRemaining = watch(timeRemainingProvider(id));
          print(
              "building CircularAnimation for $id with ${timeRemaining}s left");
          return CircularPercentIndicator(
            radius: 150,
            lineWidth: 10,
            percent: (initialDuration - timeRemaining) / initialDuration,
            center: Container(
                margin: EdgeInsets.all(20.0),
                // decoration: BoxDecoration(shape: BoxShape.circle),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$timeRemaining/$initialDuration',
                          style: Theme.of(context).textTheme.headline5),
                    ])),
            progressColor: Theme.of(context).accentColor,
            circularStrokeCap: CircularStrokeCap.round,
          );
        }),
      ),
      Consumer(builder: (context, watch, child) {
        print("building Play/Pause button for $id");
        TimerState timerState = watch(timerStateProvider(id));
        if (timerState == TimerState.started) {
          return Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              child: PauseButton(id),
            ),
          );
        } else {
          return Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              child: StartButton(id),
            ),
          );
        }
      }),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          child: ResetButton(id),
        ),
      )
    ]);
  }
}

class StartButton extends StatelessWidget {
  final UniqueKey id;
  const StartButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerNotifierProvider(id)).startTimer();
      },
      child: Icon(Icons.play_arrow),
      mini: true,
    );
  }
}

class PauseButton extends StatelessWidget {
  final UniqueKey id;
  const PauseButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerNotifierProvider(id)).pauseTimer();
      },
      child: Icon(Icons.pause),
      mini: true,
    );
  }
}

class ResetButton extends StatelessWidget {
  final UniqueKey id;
  const ResetButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerNotifierProvider(id)).resetTimer();
      },
      child: Icon(Icons.replay),
      mini: true,
    );
  }
}
