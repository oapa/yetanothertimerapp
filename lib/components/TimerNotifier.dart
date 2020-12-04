import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel> {
  UniqueKey id;
  int initialDuration;
  TimerState timerState;

  TimerNotifier(this.id, this.initialDuration, this.timerState)
      : super(TimerModel(initialDuration, TimerState.initial));

  final Ticker ticker = Ticker();
  StreamSubscription<int> tickerSubscription;

  void startTimer() {
    if (state.timerState == TimerState.paused) {
      _restartTimer();
    } else {
      _startTimer();
    }
  }

  void _restartTimer() {
    tickerSubscription?.resume();
    state.timerState = TimerState.started;
  }

  void _startTimer() {
    tickerSubscription?.cancel();
    state = TimerModel(initialDuration, TimerState.started);
    tickerSubscription = ticker.tick(ticks: initialDuration).listen((duration) {
      // timeRemaining = duration;
      print("${duration}s remaining");
      state = TimerModel(duration, TimerState.started);
    });

    tickerSubscription.onDone(() {
      state = TimerModel(state.timeRemaining, TimerState.finished);
    });

    state.timerState = TimerState.started;
  }

  void pauseTimer() {
    tickerSubscription?.pause();
    state = TimerModel(state.timeRemaining, TimerState.paused);
  }

  void resetTimer() {
    tickerSubscription?.cancel();
    state = TimerModel(initialDuration, TimerState.initial);
  }

  @override
  void dispose() {
    print("****timer was disposed");
    tickerSubscription?.cancel();
    super.dispose();
  }

  static String formattedDuration(int duration) {
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String formattedTime(DateTime timestamp) {
    return "${timestamp?.hour}:"
        "${timestamp?.minute.toString().padLeft(2, "0")}:"
        "${timestamp?.second.toString().padLeft(2, "0")}";
  }

  String timerStatus() {
    switch (state.timerState) {
      case TimerState.initial:
        {
          return "Time created";
        }
      case TimerState.started:
        {
          return "Timer started";
        }
      case TimerState.paused:
        {
          return "Timer paused";
        }
      case TimerState.finished:
        {
          return "Timer finished";
        }
    }
    return "Unknown status of timer";
  }
}

class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(
      Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}

enum TimerState {
  initial,
  started,
  paused,
  finished,
}

class TimerModel {
  int timeRemaining;
  TimerState timerState;

  TimerModel(this.timeRemaining, this.timerState);
}

// class TimerButtonsContainer extends StatelessWidget {
//   final UniqueKey uniqueKey;
//   final TimerState timerState;
//   const TimerButtonsContainer({Key key, this.uniqueKey, this.timerState})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print('building TimerButtonsContainer');
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (timerState == TimerState.initial) ...[
//           StartButton(uniqueKey: uniqueKey),
//         ],
//         if (timerState == TimerState.started) ...[
//           PauseButton(uniqueKey: uniqueKey),
//           SizedBox(
//             width: 20,
//           ),
//           ResetButton(uniqueKey: uniqueKey),
//         ],
//         if (timerState == TimerState.paused) ...[
//           StartButton(uniqueKey: uniqueKey),
//           SizedBox(
//             width: 20,
//           ),
//           ResetButton(uniqueKey: uniqueKey),
//         ],
//         if (timerState == TimerState.finished) ...[
//           ResetButton(uniqueKey: uniqueKey),
//         ]
//       ],
//     );
//   }
// }

// class StartButton extends StatelessWidget {
//   final UniqueKey uniqueKey;
//   const StartButton({Key key, this.uniqueKey}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         print("start button pressed for $uniqueKey");
//         context.read(timerProvider(uniqueKey)).startTimer();
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
//         context.read(timerProvider()).pauseTimer();
//       },
//       child: Icon(Icons.pause),
//     );
//   }
// }

// class ResetButton extends StatelessWidget {
//   final UniqueKey uniqueKey;
//   const ResetButton({Key key, this.uniqueKey}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         context.read(timerProvider(uniqueKey)).resetTimer();
//       },
//       child: Icon(Icons.replay),
//     );
//   }
// }
