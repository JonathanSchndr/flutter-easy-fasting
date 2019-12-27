import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Easy Fasting'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFasting = false;
  DateTime _currentFastingStart;
  String _currentFastingTimer;

  List<Map<String, String>> _historyFasting = [];

  @override
  void initState() {
    Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              _currentFastingTimer = new DateTime.now()
                  .difference(_currentFastingStart)
                  .toString()
                  .substring(0, 7);
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment(0.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(_isFasting ? _currentFastingTimer : "0:00:00",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 36)),
              ),
            ),
            Container(
              alignment: Alignment(0.0, 0.0),
              child: Text("History",
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 24)),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Start')),
                DataColumn(label: Text('End')),
                DataColumn(label: Text('Duration')),
              ],
              rows: _historyFasting.reversed
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element["start"])),
                            DataCell(Text(element["end"])),
                            DataCell(Text(element["duration"])),
                          ],
                        )),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isFasting) {
              showDialog(
                context: context,
                child: new SimpleDialog(
                  title: const Text('Stop fasting?'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          _isFasting = false;
                          _historyFasting.add({
                            "start": DateFormat("dd.MM.yyyy HH:mm:ss")
                                .format(_currentFastingStart),
                            "end": DateFormat("dd.MM.yyyy HH:mm:ss")
                                .format(DateTime.now()),
                            "duration": _currentFastingTimer
                          });

                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
                      },
                      child: const Text('Yes'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            } else {
              _isFasting = true;
              _currentFastingTimer = "0:00:00";
              _currentFastingStart = DateTime.now();
            }
          });
        },
        child: Icon(_isFasting ? Icons.stop : Icons.play_arrow),
        backgroundColor: _isFasting ? Colors.red : Colors.green,
      ),
    );
  }
}
