import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

// class TimerList extends StateNotifier<List<TimerNotifier>> {
//   TimerList(List<TimerNotifier> initialTimers) : super(initialTimers ?? []);

//   void add(UniqueKey uniqueKey, int initialDuration,
//       {TimerState timerState: TimerState.initial}) {
//     // Key newTimerKey = UniqueKey();
//     print("adding a new timer with $uniqueKey");
//     state = [...state, TimerNotifier(uniqueKey, initialDuration, timerState)];
//     print(state);
//   }

//   // void edit(UniqueKey uniqueKey, int newDuration) {
//   //   state[uniqueKey] =
//   //       TimerNotifier(key: uniqueKey, timeRemaining: newDuration);
//   // }

//   void remove(UniqueKey targetTimerKey) {
//     state = state.where((timer) => timer.id != targetTimerKey).toList();
//   }
// }

class TimerList extends ChangeNotifier {
  List<TimerNotifier> timerList = <TimerNotifier>[];
  TimerList(this.timerList);

  void add(UniqueKey uniqueKey, int initialDuration,
      {TimerState timerState: TimerState.initial}) {
    // Key newTimerKey = UniqueKey();
    print("adding a new timer with $uniqueKey");
    timerList.add(TimerNotifier(uniqueKey, initialDuration, timerState));
    print(timerList);
    notifyListeners();
  }

  // void edit(UniqueKey uniqueKey, int newDuration) {
  //   state[uniqueKey] =
  //       TimerNotifier(key: uniqueKey, timeRemaining: newDuration);
  // }

  void remove(UniqueKey targetTimerKey) {
    timerList = timerList.where((timer) => timer.id != targetTimerKey).toList();
    notifyListeners();
  }
}

// class TimerMap extends ChangeNotifier {
//   Map<UniqueKey, TimerNotifier> timerMap = {};

//   TimerMap(this.timerMap);

//   void add(UniqueKey uniqueKey, int initialDuration) {
//     print("adding a new timer");
//     // UniqueKey timerUniqueKey = UniqueKey();
//     timerMap[uniqueKey] =
//         TimerNotifier(uniqueKey, initialDuration, TimerState.initial);
//     print(timerMap);
//     notifyListeners();
//   }

//   void edit(UniqueKey uniqueKey, int newDuration) {
//     timerMap[uniqueKey] =
//         TimerNotifier(uniqueKey, newDuration, TimerState.initial);
//     notifyListeners();
//   }

//   void remove(UniqueKey uniqueKey) {
//     timerMap.remove(uniqueKey);
//     notifyListeners();
//   }
// }
