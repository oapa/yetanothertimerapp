import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerMap extends ChangeNotifier {
  Map<UniqueKey, TimerNotifier> timerMap = {};

  TimerMap(this.timerMap);

  void add(
      {@required UniqueKey id,
      @required int initialDuration,
      TimerState timerState = TimerState.initial,
      String timerLabel,
      String timerGroup}) {
    print("adding a new timer $id");
    timerMap[id] = TimerNotifier(
        id: id,
        initialDuration: initialDuration,
        timerState: timerState,
        timerLabel: timerLabel,
        timerGroup: timerGroup);
    notifyListeners();
  }

  void edit(
      {@required UniqueKey id,
      @required int initialDuration,
      TimerState timerState = TimerState.initial,
      String timerLabel,
      String timerGroup}) {
    print("Editing timer $id");
    timerMap[id].updateTimer(TimerNotifier(
        id: id,
        initialDuration: initialDuration,
        timerState: timerState,
        timerLabel: timerLabel,
        timerGroup: timerGroup));
    notifyListeners();
  }

  void remove(UniqueKey id) {
    print("removing timer $id");
    timerMap.remove(id);
    notifyListeners();
  }
}
