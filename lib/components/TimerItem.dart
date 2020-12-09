import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/components/CreateTimer.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

final double buttonInset = 15.0;
final double maxTimerItemSize = 300;

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
        "building TimerCircularAnimation for $id with ${timeRemaining}s left out of ${initialDuration}s");

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
  int numTimers = (contextWidth / maxTimerItemSize).round();
  return ((contextWidth - 40) - (numTimers - 1) * 10) / numTimers - 50;
}

class TimerInfoContainer extends StatelessWidget {
  //TODO: Add ability for user to select info widgets for each area
  final UniqueKey id;
  const TimerInfoContainer(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building TimerInfoContainer for $id");
    double contextWidth = MediaQuery.of(context).size.width;
    double circleRadius = calculateDialRadius(contextWidth);

    return SizedBox(
        height: circleRadius + 10,
        width: circleRadius + 10,
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
  //TODO: Format time remaining for clarity on timer state and consistent readability
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
  //TODO: Format initial duration for clarity
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
  //TODO: Find better place for label
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
      title: Text("Edit timer"),
      content: CreateTimerForm(id: id),
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
              padding: EdgeInsets.fromLTRB(0, buttonInset, buttonInset, 0),
              child: Icon(Icons.edit))),
    ));
  }
}

Color customProgressColor(TimerState timerState) {
  //TODO: Use theme swatch instead of constants for progress colors
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
  //TODO: Better formatting for ETA (e.g. ETA heading and +n days indicator for overflow)
  final UniqueKey id;
  ETAInfo(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TimerState timerState = watch(timerStateProvider(id));
    if (timerState == TimerState.started || timerState == TimerState.finished) {
      return Text(formattedTime(context.read(timerNotifierProvider(id)).eta),
          style: Theme.of(context).textTheme.headline6);
    } else {
      return Text("-", style: Theme.of(context).textTheme.headline6);
    }
  }
}
