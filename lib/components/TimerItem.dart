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
    return SizedBox(
        height: 400,
        width: 400,
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                width: 200,
                child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.red)),
              )),
          TimerCircularAnimation(id),
          TimerInfoContainer(id),
          TimerMoveButton(id),
          TimerEditButton(id),
          StartPauseButton(id),
          ResetButton(id),
          TimerLabelInfo(id)
        ]));
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
    Color progressColor = customProgressColor(timerState);
    print(
        "building TimerCircularAnimation for $id with ${timeRemaining}s left");

    return CircularPercentIndicator(
      radius: 200,
      lineWidth: 10,
      percent: double.parse(
          ((initialDuration - timeRemaining) / initialDuration)
              .toStringAsFixed(2)),
      // center: TimerInfo(id),
      progressColor: progressColor,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}

class TimerInfoContainer extends StatelessWidget {
  final UniqueKey id;
  const TimerInfoContainer(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerInfoContainer for $id");

    return SizedBox(
        height: 250,
        width: 250,
        child: Container(
          margin: EdgeInsets.all(15.0),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TimeRemainingInfo(id),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            InitialDurationInfo(id),
            Divider(thickness: 1, color: Colors.grey),
            ETAInfo(id),
          ]),
        ));
  }
}

class TimeRemainingInfo extends ConsumerWidget {
  final UniqueKey id;
  const TimeRemainingInfo(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // DateTime startTime = context.read(timerNotifierProvider(id)).startTime;
    int timeRemaining = watch(timeRemainingProvider(id));
    // TimerState timerState = watch(timerStateProvider(id));
    print("building TimeRemainingInfo for $id with ${timeRemaining}s left");

    return Text(formattedDuration(timeRemaining),
        style: Theme.of(context).textTheme.headline6);
  }
}

class InitialDurationInfo extends StatelessWidget {
  final UniqueKey id;
  const InitialDurationInfo(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int initialDuration =
        context.read(timerNotifierProvider(id)).initialDuration;
    print("building InitialDurationInfo for $id");

    return Text(formattedDuration(initialDuration),
        style: Theme.of(context).textTheme.headline6);
  }
}

class TimerLabelInfo extends StatelessWidget {
  final UniqueKey id;
  const TimerLabelInfo(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String timerLabel = context.read(timerNotifierProvider(id)).timerLabel;
    print("building TimerLabel for $id with $timerLabel");

    return Positioned(
        bottom: 0,
        child: Text(timerLabel ?? "",
            style: Theme.of(context).textTheme.bodyText2));
  }
}

class TimerMoveButton extends StatelessWidget {
  final UniqueKey id;
  const TimerMoveButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerMoveButton for $id");

    return Positioned(
      top: 10,
      left: 10,
      child: Icon(Icons.drag_indicator),
    );
  }
}

class TimerEditButton extends StatelessWidget {
  final UniqueKey id;
  const TimerEditButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerEditButton for $id");
// set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {},
    );

// set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    return Positioned(
      top: 0,
      right: 0,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
        child: Icon(Icons.edit),
        mini: true,
      ),
    );
  }
}

Color customProgressColor(TimerState timerState) {
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

class ETAInfo extends ConsumerWidget {
  final UniqueKey id;
  ETAInfo(this.id, {Key key}) : super(key: key);

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
