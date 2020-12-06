import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/Constructors.dart';

class QuickAddTimer extends StatefulWidget {
  @override
  QuickAddTimerState createState() {
    return QuickAddTimerState();
  }
}

class QuickAddTimerState extends State<QuickAddTimer> {
  final FocusScopeNode _node = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  final hourEntryController = new TextEditingController();
  final minuteEntryController = new TextEditingController();
  final secondsEntryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 120.0,
        maxHeight: 120.0,
        child: Container(
          color: Colors.blue[50],
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Center(
            child: Form(
              key: _formKey,
              child: FocusScope(
                node: _node,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: hourEntryController,
                        maxLength: 2,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                          labelText: 'Hours',
                          border: OutlineInputBorder(),
                          // errorText: validationService.hours.error;
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return validateHours(value);
                        },
                        onChanged: (value) => autoAdvance(value),
                        onFieldSubmitted: (value) => createNewTimer(value),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: minuteEntryController,
                        maxLength: 2,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                          // errorText: validationService.hours.error;
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return validateMinutes(value);
                        },
                        onChanged: (value) => autoAdvance(value),
                        onFieldSubmitted: (value) => createNewTimer(value),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: secondsEntryController,
                        maxLength: 2,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                          labelText: 'Seconds',
                          border: OutlineInputBorder(),
                          // errorText: validationService.hours.error;
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return validateSeconds(value);
                        },
                        onFieldSubmitted: (value) => createNewTimer(value),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: FloatingActionButton(
                          child: Icon(Icons.add, size: 50),
                          onPressed: () {
                            createNewTimerButton();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  void createNewTimerButton() {
    createNewTimer("");
  }

  void autoAdvance(String value) {
    if (value.length == 2) {
      print("length of 2, advancing");
      _node.nextFocus();
    }
  }

  void createNewTimer(String value) {
    if (_formKey.currentState.validate()) {
      print(
          "Creating new timer for ${hourEntryController.text}h ${minuteEntryController.text}m ${secondsEntryController.text}s");
      int totalSeconds =
          (int.tryParse(hourEntryController.text) ?? 0) * 60 * 60 +
              (int.tryParse(minuteEntryController.text) ?? 0) * 60 +
              (int.tryParse(secondsEntryController.text) ?? 0);

      context.read(timerListProvider).add(UniqueKey(), totalSeconds);
      _formKey.currentState?.reset();
    } else {}
  }

  String validateHours(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null || value == null) {
      // _node.nextFocus();
      return null;
    } else if (minuteEntryController.text != null ||
        secondsEntryController.text != null) {
      return null;
    } else {
      return "Enter as int";
    }
  }

  String validateMinutes(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return null;
    } else if (hourEntryController.text != null ||
        secondsEntryController.text != null) {
      return null;
    } else {
      return "Enter as int";
    }
  }

  String validateSeconds(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return null;
    } else if (hourEntryController.text != null ||
        minuteEntryController.text != null) {
      return null;
    } else {
      return "Enter as int";
    }
  }
}
