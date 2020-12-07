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
  final labelEntryController = new TextEditingController();
  String groupName;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 125.0,
        maxHeight: 125.0,
        child: Container(
          color: Colors.blue[50],
          padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
          child: Form(
            key: _formKey,
            child: FocusScope(
              node: _node,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: hourEntryController,
                      // maxLength: 2,
                      // maxLengthEnforced: true,
                      decoration: const InputDecoration(
                          labelText: 'hr',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(height: 0)),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return validateHours(value);
                      },
                      onChanged: (value) => autoAdvance(value),
                      onFieldSubmitted: (value) => createNewTimer(value),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: minuteEntryController,
                      // maxLength: 2,
                      // maxLengthEnforced: true,
                      decoration: const InputDecoration(
                        labelText: 'min',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(height: 0),
                        // errorText: validationService.hours.error;
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return validateMinutes(value);
                      },
                      onChanged: (value) => autoAdvance(value),
                      onFieldSubmitted: (value) => createNewTimer(value),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: secondsEntryController,
                      // maxLength: 2,
                      // maxLengthEnforced: true,
                      decoration: const InputDecoration(
                        labelText: 'sec',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(height: 0),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return validateSeconds(value);
                      },
                      onFieldSubmitted: (value) => createNewTimer(value),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 60,
                    height: 55,
                    // padding: EdgeInsets.only(top: 5),
                    child: RaisedButton(
                      child: Text("ADD"),
                      onPressed: () {
                        createNewTimerButton();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 150,
                    child: TextFormField(
                      controller: labelEntryController,
                      maxLength: 30,
                      maxLengthEnforced: true,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                        hintText: '[Optional]',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(height: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // errorText: validationService.hours.error;
                      ),
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.text,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (value) {
                      //   return validateLabel(value);
                      // },
                      onFieldSubmitted: (value) => createNewTimer(value),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 250,
                    // padding: EdgeInsets.all(4),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Group',
                        hintText: '[Optional]',
                        border: const OutlineInputBorder(),
                        errorStyle: TextStyle(height: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Container(
                          padding: EdgeInsets.only(left: 10, right: 20),
                          width: 80,
                          child: RaisedButton(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(Icons.add_rounded),
                            // shape: CircleBorder(),
                            onPressed: () {
                              addGroup();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (value) {
                      //   return validateGroupName(value);
                      // },
                      items: [
                        DropdownMenuItem(
                            child: Text("Default"), value: "Default")
                      ],
                      onChanged: (value) => groupName = value,
                    ),
                  ),
                ],
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
    if (intValue != null) {
      return null;
    } else if (minuteEntryController.text.length > 0 ||
        secondsEntryController.text.length > 0) {
      print(
          "no hours found, but found ${minuteEntryController.text} and ${secondsEntryController.text}");
      return null;
    } else {
      return "Enter an int";
    }
  }

  String validateMinutes(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return null;
    } else if (hourEntryController.text.length > 0 ||
        secondsEntryController.text.length > 0) {
      return null;
    } else {
      return "Enter an int";
    }
  }

  String validateSeconds(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return null;
    } else if (hourEntryController.text.length > 0 ||
        minuteEntryController.text.length > 0) {
      return null;
    } else {
      return "Enter an int";
    }
  }

  String validateLabel(String value) {
    if (value != null) {
      return null;
    } else {
      return "Enter an int";
    }
  }

  String validateGroupName(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return null;
    } else if (hourEntryController.text.length > 0 ||
        minuteEntryController.text.length > 0) {
      return null;
    } else {
      return "Enter an int";
    }
  }

  void addGroup() {
    print("adding group name");
  }
}
