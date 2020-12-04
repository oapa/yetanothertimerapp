import 'package:flutter/material.dart';

class TimerFormField extends StatelessWidget {
  final String labelText;
  final String errorText;
  final Function onSaved;
  final String initialValue;

  TimerFormField(
      {@required this.labelText,
      @required this.errorText,
      @required this.onSaved,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: Theme.of(context).textTheme.caption.copyWith(
            fontSize: 16.0,
            color: Theme.of(context).textTheme.headline6.color,
          ),
      decoration: InputDecoration(
          labelText: labelText,
          errorStyle: TextStyle(
            fontSize: 15.0,
            height: 0.9,
          ),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.trim().isEmpty) {
          return errorText;
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
