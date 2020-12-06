import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerItem extends StatelessWidget {
  final UniqueKey id;
  const TimerItem(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building $id TimerTextWidget');
    return Stack(alignment: Alignment.center, children: [
      TimerCircularAnimation(id),
      StartPauseButton(id),
      ResetButton(id),
    ]);
  }
}

class TimerCircularAnimation extends ConsumerWidget {
  final UniqueKey id;
  const TimerCircularAnimation(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    int initialDuration =
        context.read(timerNotifierProvider(id)).initialDuration;
    // DateTime startTime = context.read(timerNotifierProvider(id)).startTime;
    int timeRemaining = watch(timeRemainingProvider(id));
    TimerState timerState = watch(timerStateProvider(id));
    Color customProgressColor = customerProgressColor(timerState);
    print(
        "building TimerCircularAnimation for $id with ${timeRemaining}s left");

    return CircularPercentIndicator(
      radius: 200,
      lineWidth: 10,
      percent: double.parse(
          ((initialDuration - timeRemaining) / initialDuration)
              .toStringAsFixed(2)),
      center: Container(
          margin: EdgeInsets.all(20.0),
          // decoration: BoxDecoration(shape: BoxShape.circle),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(formattedDuration(timeRemaining),
                style: Theme.of(context).textTheme.headline6),
            Divider(thickness: 2, color: Colors.grey),
            Text(formattedDuration(initialDuration),
                style: Theme.of(context).textTheme.headline6),
            Divider(thickness: 2, color: Colors.grey),
            ETAString(id),
          ])),
      progressColor: customProgressColor,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}

Color customerProgressColor(TimerState timerState) {
  switch (timerState) {
    case TimerState.paused:
      return Colors.blueGrey;
    case TimerState.finished:
      return Colors.green;
    default:
      return Colors.blue;
  }
}

class StartPauseButton extends ConsumerWidget {
  final UniqueKey id;
  const StartPauseButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerState timerState = watch(timerStateProvider(id));
    if (timerState == TimerState.started) {
      return Positioned(
        left: 0,
        bottom: 0,
        child: FloatingActionButton(
          onPressed: () {
            context.read(timerNotifierProvider(id)).pauseTimer();
          },
          child: Icon(Icons.pause),
          mini: true,
        ),
      );
    } else {
      return Positioned(
        left: 0,
        bottom: 0,
        child: FloatingActionButton(
          onPressed: () {
            context.read(timerNotifierProvider(id)).startTimer();
          },
          child: Icon(Icons.play_arrow),
          mini: true,
        ),
      );
    }
  }
}

class ResetButton extends ConsumerWidget {
  final UniqueKey id;
  const ResetButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerState timerState = watch(timerStateProvider(id));
    Color buttonColor = (timerState == TimerState.initial)
        ? Colors.grey
        : Theme.of(context).floatingActionButtonTheme.backgroundColor;
    // Color customHoverColor = (timerState == TimerState.initial)
    //     ? Colors.grey
    //     : Theme.of(context).floatingActionButtonTheme.backgroundColor;
    // double customElevation = (timerState == TimerState.initial) ? 0 : 6;
    // double customHoverElevation = (timerState == TimerState.initial) ? 0 : 8;
    return Positioned(
        right: 0,
        bottom: 0,
        child: FloatingActionButton(
          onPressed: () {
            if (timerState == TimerState.initial) {
              return null;
            } else {
              context.read(timerNotifierProvider(id)).resetTimer();
            }
          },
          child: Icon(
            Icons.replay,
          ),
          mini: true,
          backgroundColor: buttonColor,
          // elevation: customElevation,
          // hoverElevation: customHoverElevation,
          // hoverColor: customHoverColor,
          // splashColor: ,
        ));
  }
}

String formattedDuration(int duration) {
  final int hours = (duration / 60 / 60).floor();
  final String hoursText = (hours > 0) ? hours.toString() + "h " : "";
  final int minutes = ((duration / 60) % 60).floor();
  final String minutesText = (minutes > 0) ? minutes.toString() + "m " : "";
  final int seconds = (duration % 60).floor();
  final String secondsText = (seconds > 0) ? seconds.toString() + "s " : "";
  return '$hoursText$minutesText$secondsText';
}

String formattedTime(DateTime timestamp) {
  return DateFormat.jms().format(timestamp);
}

class ETAString extends ConsumerWidget {
  final UniqueKey id;
  ETAString(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerState timerState = watch(timerStateProvider(id));
    switch (timerState) {
      case TimerState.started:
        return Text(formattedTime(context.read(timerNotifierProvider(id)).eta),
            style: Theme.of(context).textTheme.headline6);
      case TimerState.finished:
        return Text(formattedTime(context.read(timerNotifierProvider(id)).eta),
            style: Theme.of(context).textTheme.headline6);
      default:
        return Text("-", style: Theme.of(context).textTheme.headline6);
    }
  }
}
