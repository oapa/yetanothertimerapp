import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yetanothertimerapp/shared/Providers.dart';
import 'package:yetanothertimerapp/shared/Constructors.dart';

class CreateTimerDialog extends StatelessWidget {
  final UniqueKey id;
  final bool edit;
  const CreateTimerDialog(this.id, {Key key, this.edit = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      titlePadding: EdgeInsets.only(left: 24, bottom: 10),
      title: Stack(children: [
        Positioned(
            top: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.topRight,
                height: 50,
                width: 50,
                child: FlatButton(
                  child: Icon(Icons.cancel),
                  onPressed: () => Navigator.pop(context),
                ))),
        Padding(padding: EdgeInsets.only(top: 24), child: Text("Add a timer"))
      ]),
      content: CreateTimerForm(id, edit: edit),
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
  final bool edit;
  CreateTimerForm(this.id, {this.edit = false});

  @override
  CreateTimerFormState createState() {
    return CreateTimerFormState(this.id, this.edit);
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
  final bool edit;

  CreateTimerFormState(this.id, this.edit);

  @override
  Widget build(BuildContext context) {
    if (edit) {
      String oldHours = context.read(timerNotifierProvider(id)).hours;
      String oldMinutes = context.read(timerNotifierProvider(id)).minutes;
      String oldSeconds = context.read(timerNotifierProvider(id)).seconds;
      hourEntryController.text = (int.tryParse(oldHours) > 0) ? oldHours : '';
      minuteEntryController.text =
          (int.tryParse(oldMinutes) > 0) ? oldMinutes : '';
      secondsEntryController.text =
          (int.tryParse(oldSeconds) > 0) ? oldSeconds : '';
      secondsEntryController.selection = TextSelection.fromPosition(
          TextPosition(offset: secondsEntryController.text.length));
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
                  // onChanged: (value) => autoAdvance(value),
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
      if (minuteEntryController.text.length > 2) {
        hourEntryController.text += minuteEntryController.text.substring(0, 1);
        minuteEntryController.text = minuteEntryController.text.substring(
          1,
        );
      }
    }
    if (value.length == 1 && (minuteEntryController.text.length > 0)) {
      secondsEntryController.text = minuteEntryController.text
              .substring(minuteEntryController.text.length - 1) +
          secondsEntryController.text;
      if (minuteEntryController.text.length == 1) {
        minuteEntryController.text = '';
      } else if (minuteEntryController.text.length == 2) {
        minuteEntryController.text = minuteEntryController.text
            .substring(0, minuteEntryController.text.length - 1);
        if (hourEntryController.text.length == 1) {
          minuteEntryController.text =
              hourEntryController.text + minuteEntryController.text;
          hourEntryController.text = '';
        } else if (hourEntryController.text.length >= 2) {
          minuteEntryController.text = hourEntryController.text
                  .substring(hourEntryController.text.length - 1) +
              minuteEntryController.text;
          hourEntryController.text = hourEntryController.text
              .substring(0, hourEntryController.text.length - 1);
        }
      }
    }
    secondsEntryController.selection = TextSelection.fromPosition(
        TextPosition(offset: secondsEntryController.text.length));
  }

  void submitTimerForm(String value) {
    if (_formKey.currentState.validate()) {
      int totalSeconds =
          (int.tryParse(hourEntryController.text) ?? 0) * 60 * 60 +
              (int.tryParse(minuteEntryController.text) ?? 0) * 60 +
              (int.tryParse(secondsEntryController.text) ?? 0);
      if (edit) {
        context.read(timerListProvider).edit(
            id: id,
            initialDuration: totalSeconds,
            timerLabel: labelEntryController.text.trim());
      } else {
        context.read(timerListProvider).add(
            id: id,
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
