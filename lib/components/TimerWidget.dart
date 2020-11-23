import 'package:flutter/material.dart';
import 'dart:async';

class YATATimer extends StatefulWidget {
  YATATimer({Key key, @required this.duration}) : super(key: key);

  final int duration;

  @override
  _YATATimerState createState() => new _YATATimerState(duration);
}

class _YATATimerState extends State<YATATimer> {
  final oneSec = const Duration(seconds: 1);
  int _duration;
  int _timeRemaining;
  DateTime _originalStartTime;
  int pauseCounter = 0;
  DateTime _startTime;
  DateTime _endTime;
  bool _isRunning = true;
  bool _isComplete = false;
  Timer timer;
  // ListTile timerTile;

  _YATATimerState(int duration) {
    _duration = duration;
    _timeRemaining = duration;
    _originalStartTime = DateTime.now();
    // _endTime = _startTime.add(Duration(seconds: _timeRemaining));
    _startTimer();
    // _isRunning = true;
  }

  void _startTimer() {
    _isRunning = true;
    _startTime = DateTime.now();
    _endTime = _startTime.add(Duration(seconds: _timeRemaining));
    timer = Timer.periodic(
        oneSec,
        (Timer timer) => {
              setState(
                () {
                  if (_timeRemaining < 1) {
                    timer.cancel();
                    _isComplete = true;
                    _isRunning = false;
                  } else {
                    _timeRemaining -= 1;
                  }
                },
              )
            });
  }

  void _pauseTimer() {
    pauseCounter += 1;
    setState(() {
      timer.cancel();
      _isRunning = false;
    });
  }

  String formattedTime(DateTime timestamp) {
    return "${timestamp?.hour}:"
        "${timestamp?.minute.toString().padLeft(2, "0")}:"
        "${timestamp?.second.toString().padLeft(2, "0")}";
  }

  String formatETA() {
    if (_isRunning) {
      return "Started at: ${formattedTime(_startTime)} to finish at: ${formattedTime(_endTime)}";
    } else if (_isComplete) {
      return "Timer completed at: ${formattedTime(_endTime)}";
    } else {
      return "Timer is paused";
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {
          print("registered double tap");
          _isRunning ? _pauseTimer() : _startTimer();
        },
        child: ListTile(
            title: Text("$_timeRemaining / $_duration seconds left"),
            subtitle: Text(formatETA())));
  }
}
