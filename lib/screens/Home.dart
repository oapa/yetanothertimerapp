import 'package:flutter/material.dart';
import 'package:yetanothertimerapp/components/TimerWidget.dart';

class YATAHomePage extends StatefulWidget {
  YATAHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _YATAState createState() => _YATAState();
}

class _YATAState extends State<YATAHomePage> {
  final List<Widget> _timerList = <Widget>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Yet Another Timer App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: ListView(children: _getTimers()),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(context),
            tooltip: 'Add Timer',
            child: Icon(Icons.add),
          ),
        ));
  }

  void _addTimer(int duration) {
    setState(() {
      _timerList.add(YATATimer(duration: duration));
    });
    _textFieldController.clear();
  }

  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a timer'),
            content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                    hintText: 'Enter timer duration in seconds')),
            actions: <Widget>[
              FlatButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTimer(int.parse(_textFieldController.text));
                },
              ),
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('DURATION'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('END TIME'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getTimers() {
    List<Widget> _timerWidgets = [];
    for (YATATimer timerWidget in _timerList) {
      _timerWidgets.add(timerWidget);
    }
    return _timerWidgets;
  }
}
