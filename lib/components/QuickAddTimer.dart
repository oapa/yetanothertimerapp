import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/components/Providers.dart';
import 'package:yetanothertimerapp/components/SharedConstructors.dart';

class QuickAddTimer extends StatelessWidget {
  const QuickAddTimer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("building Dashboard widget");
    final newTimerController = TextEditingController();

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
            color: Colors.amber,
            child: Center(
              child: TextField(
                key: UniqueKey(),
                controller: newTimerController,
                decoration: const InputDecoration(
                  labelText: 'How long to set new timer?',
                ),
                onSubmitted: (value) {
                  context
                      .read(timerListProvider)
                      .add(UniqueKey(), int.parse(value));
                  newTimerController.clear();
                },
              ),
            )),
      ),
    );
  }
}
