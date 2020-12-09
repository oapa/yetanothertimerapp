import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel> {
  UniqueKey id;
  int initialDuration;
  String hours;
  String minutes;
  String seconds;
  String timerLabel;
  String timerGroup;
  TimerState timerState;
  DateTime eta;
  DateTime startTime;

  TimerNotifier(
      {@required this.id,
      @required this.initialDuration,
      this.timerState = TimerState.initial,
      this.timerLabel,
      this.timerGroup})
      : hours = (initialDuration / 3600).floor().toString(),
        minutes = ((initialDuration % 3600) / 60).floor().toString(),
        seconds = (initialDuration % 60).toString(),
        super(
            TimerModel(timeRemaining: initialDuration, timerState: timerState));

  final Ticker ticker = Ticker();
  StreamSubscription<int> tickerSubscription;

  void startTimer() {
    tickerSubscription?.cancel();
    eta = DateTime.now().add(Duration(seconds: state.timeRemaining));
    tickerSubscription =
        ticker.tick(ticks: state.timeRemaining).listen((duration) {
      // print("${duration}s remaining");
      state =
          TimerModel(timeRemaining: duration, timerState: TimerState.started);
    });

    tickerSubscription?.onDone(() {
      state = TimerModel(
          timeRemaining: state.timeRemaining, timerState: TimerState.finished);
    });
  }

  void pauseTimer() {
    tickerSubscription?.cancel();
    state = TimerModel(
        timeRemaining: state.timeRemaining, timerState: TimerState.paused);
  }

  void resetTimer() {
    tickerSubscription?.cancel();
    state = TimerModel(
        timeRemaining: initialDuration, timerState: TimerState.initial);
  }

  @override
  void dispose() {
    print("****timer $id was disposed");
    tickerSubscription?.cancel();
    super.dispose();
  }

  void updateTimer(TimerNotifier newTimerNotifier) {
    initialDuration = newTimerNotifier.initialDuration;
    timerState = newTimerNotifier.timerState;
    timerLabel = newTimerNotifier.timerLabel;
    timerGroup = newTimerNotifier.timerGroup;
    hours = (initialDuration / 3600).floor().toString();
    minutes = ((initialDuration % 3600) / 60).floor().toString();
    seconds = (initialDuration % 60).toString();
    state = TimerModel(timeRemaining: initialDuration, timerState: timerState);
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
  String hours;
  String minutes;
  String seconds;
  TimerState timerState;

  TimerModel({@required this.timeRemaining, @required this.timerState});
}
