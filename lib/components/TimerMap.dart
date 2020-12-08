import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerMap extends ChangeNotifier {
  Map<UniqueKey, TimerNotifier> timerMap = {};

  TimerMap(this.timerMap);

  void add(UniqueKey uniqueKey, int initialDuration, {String timerLabel}) {
    print("adding a new timer $uniqueKey");
    timerMap[uniqueKey] = TimerNotifier(
        uniqueKey, initialDuration, TimerState.initial,
        timerLabel: timerLabel);
    notifyListeners();
  }

  void edit(UniqueKey uniqueKey, int newDuration) {
    timerMap[uniqueKey] =
        TimerNotifier(uniqueKey, newDuration, TimerState.initial);
    notifyListeners();
  }

  void remove(UniqueKey uniqueKey) {
    print("removing timer $uniqueKey");
    timerMap.remove(uniqueKey);
    notifyListeners();
  }
}
