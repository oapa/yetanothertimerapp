import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel> {
  UniqueKey id;
  int initialDuration;
  String timerLabel;
  String timerGroup;
  TimerState timerState;
  DateTime eta;
  DateTime startTime;

  TimerNotifier(this.id, this.initialDuration, this.timerState,
      {this.timerLabel, this.timerGroup})
      : super(TimerModel(initialDuration, TimerState.initial));

  final Ticker ticker = Ticker();
  StreamSubscription<int> tickerSubscription;

  void startTimer() {
    tickerSubscription?.cancel();
    eta = DateTime.now().add(Duration(seconds: state.timeRemaining));
    tickerSubscription =
        ticker.tick(ticks: state.timeRemaining).listen((duration) {
      // print("${duration}s remaining");
      state = TimerModel(duration, TimerState.started);
    });

    tickerSubscription?.onDone(() {
      state = TimerModel(state.timeRemaining, TimerState.finished);
    });
  }

  void pauseTimer() {
    tickerSubscription?.cancel();
    state = TimerModel(state.timeRemaining, TimerState.paused);
  }

  void resetTimer() {
    tickerSubscription?.cancel();
    state = TimerModel(initialDuration, TimerState.initial);
  }

  @override
  void dispose() {
    print("****timer $id was disposed");
    tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick({int ticks = 0}) {
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
