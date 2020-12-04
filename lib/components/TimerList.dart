import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

class TimerMap extends ChangeNotifier {
  Map<UniqueKey, TimerNotifier> timerMap = {};

  TimerMap(this.timerMap);

  void add(UniqueKey uniqueKey, int initialDuration) {
    print("adding a new timer");
    // UniqueKey timerUniqueKey = UniqueKey();
    timerMap[uniqueKey] =
        TimerNotifier(uniqueKey, initialDuration, TimerState.initial);
    notifyListeners();
  }

  void edit(UniqueKey uniqueKey, int newDuration) {
    timerMap[uniqueKey] =
        TimerNotifier(uniqueKey, newDuration, TimerState.initial);
    notifyListeners();
  }

  void remove(UniqueKey uniqueKey) {
    timerMap.remove(uniqueKey);
    notifyListeners();
  }
}
