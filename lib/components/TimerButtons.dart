import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/UISettings.dart';
import 'package:yetanothertimerapp/components/CreateTimer.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerMoveButton extends StatelessWidget {
  // TODO: Implement move/reorder functionality
  final UniqueKey id;
  const TimerMoveButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerMoveButton for $id");

    return Expanded(
        child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.white)),
      onPressed: () {},
      color: Colors.blueGrey,
      textColor: Colors.white,
      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.fromLTRB(buttonInset, buttonInset, 0, 0),
              child: Icon(Icons.drag_indicator))),
    ));
  }
}

class TimerEditButton extends StatelessWidget {
  final UniqueKey id;
  const TimerEditButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerEditButton for $id");

    return Expanded(
        child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.white)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateTimerDialog(id, edit: true);
          },
        );
      },
      color: Colors.orange,
      textColor: Colors.white,
      child: Align(
          alignment: Alignment.topRight,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, buttonInset, buttonInset, 0),
              child: Icon(Icons.edit))),
    ));
  }
}

class StartPauseButton extends ConsumerWidget {
  final UniqueKey id;
  const StartPauseButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerState timerState = watch(timerStateProvider(id));
    IconData playPauseIcon =
        (timerState == TimerState.started) ? Icons.pause : Icons.play_arrow;
    return Expanded(
        child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.white)),
      onPressed: () {
        startPauseButtonAction(context, timerState);
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
              padding: EdgeInsets.fromLTRB(buttonInset, 0, 0, buttonInset),
              child: Icon(playPauseIcon))),
    ));
  }

  void startPauseButtonAction(BuildContext context, TimerState timerState) {
    if (timerState == TimerState.started) {
      context.read(timerNotifierProvider(id)).pauseTimer();
    } else {
      context.read(timerNotifierProvider(id)).startTimer();
    }
  }
}

class ResetButton extends ConsumerWidget {
  final UniqueKey id;
  const ResetButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerState timerState = watch(timerStateProvider(id));
    Color buttonColor =
        (timerState == TimerState.initial) ? Colors.grey : Colors.blue;
    return Expanded(
        child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.white)),
      onPressed: () {
        if (timerState == TimerState.initial) {
          return null;
        } else {
          context.read(timerNotifierProvider(id)).resetTimer();
        }
      },
      color: buttonColor,
      textColor: Colors.white,
      child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, buttonInset, buttonInset),
              child: Icon(Icons.replay))),
    ));
  }
}
