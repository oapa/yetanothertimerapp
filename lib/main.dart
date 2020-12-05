import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/screens/Dashboard.dart';

void main() {
  runApp(
    const ProviderScope(child: YetAnotherTimerApp()),
  );
}

class YetAnotherTimerApp extends StatelessWidget {
  const YetAnotherTimerApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yet Another Timer App',
      home: Dashboard(title: 'Timers Dashboard'),
    );
  }
}
