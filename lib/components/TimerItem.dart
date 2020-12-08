import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/components/CreateTimer.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerItem extends StatelessWidget {
  final UniqueKey id;
  const TimerItem(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building $id TimerTextWidget');
    return Stack(alignment: Alignment.center, children: [
      TimerButtonsContainer(id),
      ClipOval(child: TimerInfoContainer(id)),
      ClipOval(child: TimerCircularAnimation(id)),
      TimerLabelInfo(id)
    ]);
  }
}

class TimerButtonsContainer extends StatelessWidget {
  final UniqueKey id;
  const TimerButtonsContainer(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [TimerMoveButton(id), TimerEditButton(id)],
          )),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [StartPauseButton(id), ResetButton(id)],
          ))
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
    Color progressColor = customProgressColor(timerState);

    double contextWidth = MediaQuery.of(context).size.width;
    double circleRadius = calculateDialRadius(contextWidth);

    print(
        "building TimerCircularAnimation for $id with ${timeRemaining}s left");

    return CircularPercentIndicator(
      radius: circleRadius,
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

double calculateDialRadius(double contextWidth) {
  int maxTimerItemSize = 375;
  int numTimers = (contextWidth / maxTimerItemSize).round();
  return ((contextWidth - 40) - (numTimers - 1) * 10) / numTimers - 30;
}

class TimerInfoContainer extends StatelessWidget {
  final UniqueKey id;
  const TimerInfoContainer(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerInfoContainer for $id");
    double contextWidth = MediaQuery.of(context).size.width;
    double circleRadius = calculateDialRadius(contextWidth);

    return SizedBox(
        height: circleRadius,
        width: circleRadius,
        child: Container(
          margin: EdgeInsets.all(0.0),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TimeRemainingInfo(id),
            InitialDurationInfo(id),
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
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Icon(Icons.drag_indicator))),
    ));
  }
}

class EditTimerDialog extends StatelessWidget {
  final UniqueKey id;
  const EditTimerDialog(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add a timer"),
      content: CreateTimerForm(),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return alert;
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
            return EditTimerDialog(id);
          },
        );
      },
      color: Colors.orange,
      textColor: Colors.white,
      child: Align(
          alignment: Alignment.topRight,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Icon(Icons.edit))),
    ));
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
              padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
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
              padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Icon(Icons.replay))),
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
