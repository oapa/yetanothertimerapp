import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/components/TimerMap.dart';
import 'package:yetanothertimerapp/components/TimerNotifier.dart';

final timerListProvider = ChangeNotifierProvider<TimerMap>((ref) {
  UniqueKey timer1Key = UniqueKey();
  UniqueKey timer2Key = UniqueKey();
  return TimerMap({
    timer1Key: TimerNotifier(
        id: timer1Key, initialDuration: 20, timerState: TimerState.initial),
    timer2Key: TimerNotifier(
        id: timer2Key, initialDuration: 45, timerState: TimerState.initial)
  });
});

final _allTimers = Provider<Map<UniqueKey, TimerNotifier>>((ref) {
  return ref.watch(timerListProvider).timerMap;
});

final allTimers = Provider<Map<UniqueKey, TimerNotifier>>((ref) {
  return ref.watch(_allTimers);
});

final _timerNotifierProvider =
    StateNotifierProvider.family<TimerNotifier, UniqueKey>((ref, id) {
  return ref.watch(allTimers)[id];
});

final timerNotifierProvider = StateNotifierProvider.autoDispose
    .family<TimerNotifier, UniqueKey>((ref, id) {
  return ref.watch(_timerNotifierProvider(id));
});

final timerProvider =
    Provider.autoDispose.family<TimerNotifier, UniqueKey>((ref, id) {
  return ref.watch(timerNotifierProvider(id));
});

final _timeRemainingProvider =
    Provider.family.autoDispose<int, UniqueKey>((ref, id) {
  return ref.watch(timerNotifierProvider(id).state).timeRemaining;
});

final timeRemainingProvider =
    Provider.family.autoDispose<int, UniqueKey>((ref, id) {
  return ref.watch(_timeRemainingProvider(id));
});

final _timerStateProvider =
    Provider.family.autoDispose<TimerState, UniqueKey>((ref, id) {
  return ref.watch(timerNotifierProvider(id).state).timerState;
});

final timerStateProvider =
    Provider.family.autoDispose<TimerState, UniqueKey>((ref, id) {
  return ref.watch(_timerStateProvider(id));
});
