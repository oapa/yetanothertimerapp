import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yetanothertimerapp/components/Providers.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerItem extends StatelessWidget {
  final UniqueKey id;
  const TimerItem(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building $id TimerTextWidget');
    return TimerCircularAnimation(id);
  }
}

class TimerCircularAnimation extends StatelessWidget {
  final UniqueKey id;
  const TimerCircularAnimation(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("building TimerCircularWidget for $id");
    int initialDuration =
        context.read(timerNotifierProvider(id)).initialDuration;
    return Container(
        width: 250.0,
        height: 250.0,
        margin: EdgeInsets.all(10.0),
        child: Stack(alignment: Alignment.center, children: [
          Consumer(builder: (context, watch, child) {
            int timeRemaining = watch(timeRemainingProvider(id));
            DateTime eta = DateTime.now().add(Duration(seconds: timeRemaining));
            print(
                "building CircularAnimation for $id with ${timeRemaining}s left");
            return CircularPercentIndicator(
              radius: 150,
              lineWidth: 10,
              percent: (initialDuration - timeRemaining) / initialDuration,
              center: Container(
                  margin: EdgeInsets.all(20.0),
                  // decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(formattedDuration(timeRemaining),
                            style: Theme.of(context).textTheme.headline6),
                        Divider(thickness: 2, color: Colors.grey),
                        Text(formattedDuration(initialDuration),
                            style: Theme.of(context).textTheme.headline6),
                        Divider(thickness: 2, color: Colors.grey),
                        Text(formattedTime(eta),
                            style: Theme.of(context).textTheme.headline6),
                      ])),
              progressColor: Theme.of(context).accentColor,
              circularStrokeCap: CircularStrokeCap.round,
            );
          }),
          Consumer(builder: (context, watch, child) {
            print("building Play/Pause button for $id");
            TimerState timerState = watch(timerStateProvider(id));
            if (timerState == TimerState.started) {
              return Positioned(
                left: 0,
                bottom: 0,
                child: PauseButton(id),
              );
            } else {
              return Positioned(
                left: 0,
                bottom: 0,
                child: StartButton(id),
              );
            }
          }),
          Positioned(
            right: 0,
            bottom: 0,
            child: ResetButton(id),
          )
        ]));
  }
}

class StartButton extends StatelessWidget {
  final UniqueKey id;
  const StartButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerNotifierProvider(id)).startTimer();
      },
      child: Icon(Icons.play_arrow),
      mini: true,
    );
  }
}

class PauseButton extends StatelessWidget {
  final UniqueKey id;
  const PauseButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerNotifierProvider(id)).pauseTimer();
      },
      child: Icon(Icons.pause),
      mini: true,
    );
  }
}

class ResetButton extends StatelessWidget {
  final UniqueKey id;
  const ResetButton(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerNotifierProvider(id)).resetTimer();
      },
      child: Icon(Icons.replay),
      mini: true,
    );
  }
}

String formattedDuration(int duration) {
  final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
  final seconds = (duration % 60).floor().toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String formattedTime(DateTime timestamp) {
  return "${timestamp?.hour.toString().padLeft(2, "0")}:"
      "${timestamp?.minute.toString().padLeft(2, "0")}:"
      "${timestamp?.second.toString().padLeft(2, "0")}";
}
