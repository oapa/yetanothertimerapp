import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel> {
  UniqueKey id;
  int initialDuration;
  TimerState timerState;
  DateTime eta;

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
      // print("${duration}s remaining");
      state = TimerModel(duration, TimerState.started);
    });

    tickerSubscription?.onDone(() {
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
