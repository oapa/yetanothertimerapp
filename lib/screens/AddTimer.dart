// import 'package:flutter/material.dart';
// import 'package:yetanothertimerapp/components/TimerModel.dart';
// import 'package:yetanothertimerapp/inputs/TimerFormField.dart';
// import 'package:yetanothertimerapp/components/TimerNotifier.dart';

// class AddTimer extends StatelessWidget {
//   final TimerModel timerWidget;

//   AddTimer({this.timerWidget});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(timerWidget == null ? 'Add a timer' : 'Update timer'),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(12.0),
//             child: AddTimerForm(timerWidget: timerWidget),
//           ),
//         ));
//   }
// }

// class AddTimerForm extends StatefulWidget {
//   final TimerModel timerWidget;

//   AddTimerForm({this.timerWidget});

//   @override
//   _AddTimerFormState createState() => _AddTimerFormState();
// }

// class _AddTimerFormState extends State<AddTimerForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _timerName;
//   String _timerGroup;
//   int _duration;
//   // TODO: add ability to add timer with an end time (i.e. as alarm)
//   // DateTime _endTime;

//   @override
//   Widget build(BuildContext context) {
//     var timerNotifier = Provider.of<TimerNotifier>(context);

//     return Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             TimerFormField(
//               labelText: 'Name',
//               errorText: 'Enter a timer name',
//               initialValue: widget.timerWidget?.timerName,
//               onSaved: (value) => _timerName = value,
//             ),
//             TimerFormField(
//               labelText: 'Group',
//               errorText: 'Enter a timer group name',
//               initialValue: widget.timerWidget?.timerGroup,
//               onSaved: (value) => _timerGroup = value,
//             ),
//             TimerFormField(
//               labelText: 'Duration',
//               errorText: 'Enter a timer duration',
//               initialValue: widget.timerWidget?.duration.toString(),
//               onSaved: (value) => _duration = int.parse(value),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 22.0),
//               child: FlatButton(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6.0),
//                 ),
//                 color: Theme.of(context).buttonColor,
//                 textColor: Colors.white.withOpacity(0.9),
//                 onPressed: () {
//                   if (_formKey.currentState.validate()) {
//                     _formKey.currentState.save();
//                     final timerWidget = TimerModel(
//                         duration: _duration,
//                         timerName: _timerName,
//                         timerGroup: _timerGroup);
//                     if (widget.timerWidget == null) {
//                       timerNotifier.addTimer(timerWidget);
//                       Navigator.pop(context);
//                     } else {
//                       timerNotifier.updateTimer(
//                           widget.timerWidget, timerWidget);
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 },
//                 child: Text(
//                   widget.timerWidget == null ? 'Add Timer' : 'Update Timer',
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontFamily: 'Nunito',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
