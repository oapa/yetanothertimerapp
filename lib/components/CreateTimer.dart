import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/Constructors.dart';

class QuickAddTimerSliver extends StatelessWidget {
  QuickAddTimerSliver({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            minHeight: 125.0,
            maxHeight: 125.0,
            child: Container(
              color: Colors.blue[50],
              padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
              child: CreateTimerForm(),
            )));
  }
}

class CreateTimerDialog extends StatelessWidget {
  const CreateTimerDialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add a timer"),
      content: CreateTimerForm(),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return alert;
  }
}

class CreateTimerForm extends StatefulWidget {
  final UniqueKey id;
  CreateTimerForm({this.id});

  @override
  CreateTimerFormState createState() {
    return CreateTimerFormState(id: this.id);
  }
}

class CreateTimerFormState extends State<CreateTimerForm> {
  final FocusScopeNode _node = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  final hourEntryController = new TextEditingController();
  final minuteEntryController = new TextEditingController();
  final secondsEntryController = new TextEditingController();
  final labelEntryController = new TextEditingController();
  // final String groupName;
  final UniqueKey id;

  CreateTimerFormState({this.id});

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      hourEntryController.text = context.read(timerNotifierProvider(id)).hours;
      hourEntryController.selection = TextSelection(
          baseOffset: 0, extentOffset: hourEntryController.text.length);
      minuteEntryController.text =
          context.read(timerNotifierProvider(id)).minutes;
      minuteEntryController.selection = TextSelection(
          baseOffset: 0, extentOffset: minuteEntryController.text.length);
      secondsEntryController.text =
          context.read(timerNotifierProvider(id)).seconds;
      secondsEntryController.selection = TextSelection(
          baseOffset: 0, extentOffset: secondsEntryController.text.length);
      labelEntryController.text =
          context.read(timerNotifierProvider(id)).timerLabel;
    }
    return Form(
      key: _formKey,
      child: FocusScope(
        node: _node,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 60,
                child: TextFormField(
                  controller: hourEntryController,
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
                  onFieldSubmitted: (value) => submitTimerForm(value),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 60,
                child: TextFormField(
                  controller: minuteEntryController,
                  decoration: const InputDecoration(
                    labelText: 'min',
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(height: 0),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return validateMinutes(value);
                  },
                  onChanged: (value) => autoAdvance(value),
                  onFieldSubmitted: (value) => submitTimerForm(value),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 60,
                child: TextFormField(
                  autofocus: true,
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
                  onChanged: (value) => autoFillFromSeconds(value),
                  onFieldSubmitted: (value) => submitTimerForm(value),
                ),
              ),
            ]),
            SizedBox(height: 20),
            Container(
              width: 150,
              child: TextFormField(
                controller: labelEntryController,
                maxLength: 15,
                maxLengthEnforced: true,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  hintText: '[Optional]',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(height: 0),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (value) => submitTimerForm(value),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Group',
                  hintText: '[Optional]',
                  border: const OutlineInputBorder(),
                  errorStyle: TextStyle(height: 0),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Container(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    width: 60,
                    child: RaisedButton(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(Icons.add),
                      // shape: CircleBorder(),
                      onPressed: () {
                        addGroup();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                items: [
                  DropdownMenuItem(child: Text("Default"), value: "Default")
                ],
                onChanged: (value) => print(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  void autoAdvance(String value) {
    if (value.length == 2) {
      _node.previousFocus();
    }
  }

  void autoFillFromSeconds(String value) {
    if (value.length > 2) {
      minuteEntryController.text += value.substring(0, 1);
      secondsEntryController.text = value.substring(
        1,
      );
      secondsEntryController.selection = TextSelection.fromPosition(
          TextPosition(offset: secondsEntryController.text.length));
      if (minuteEntryController.text.length > 2) {
        hourEntryController.text += minuteEntryController.text.substring(0, 1);
        minuteEntryController.text = minuteEntryController.text.substring(
          1,
        );
      }
    }
  }

  void submitTimerForm(String value) {
    if (_formKey.currentState.validate()) {
      int totalSeconds =
          (int.tryParse(hourEntryController.text) ?? 0) * 60 * 60 +
              (int.tryParse(minuteEntryController.text) ?? 0) * 60 +
              (int.tryParse(secondsEntryController.text) ?? 0);

      if (id != null) {
        context.read(timerListProvider).edit(
            id: id,
            initialDuration: totalSeconds,
            timerLabel: labelEntryController.text.trim());
      } else {
        context.read(timerListProvider).add(
            id: UniqueKey(),
            initialDuration: totalSeconds,
            timerLabel: labelEntryController.text.trim());
      }
      _formKey.currentState?.reset();
    } else {}
  }

  String validateHours(String value) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return null;
    } else if (minuteEntryController.text.length > 0 ||
        secondsEntryController.text.length > 0) {
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

  void addGroup() {
    //TODO: Add a group on the fly
    print("adding group name");
  }
}
