import 'dart:ffi';

import 'package:converter2/converter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const List<String> imperial = <String>[
  'inch',
  'foot',
  'yard',
  'pole',
  'chain',
  'furlong',
  'mile',
  'league'
];
const List<String> metric = <String>['mm', 'cm', 'dm', 'm', 'km'];

List<DropdownMenuItem<String>> firstUnitList =
    imperial.map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  );
}).toList();

List<DropdownMenuItem<String>> secondUnitList =
    metric.map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  );
}).toList();

String firstUnit = firstUnitList.first.value.toString();
String secondUnit = secondUnitList.first.value.toString();

var firstValue = "";
var secondValue = "";

class _MyHomePageState extends State<MyHomePage> {
  bool isFromImperialToMetric = true;

  var tempUnitList;
  var tempChoosenUnit;
  var tempVal;

  final TextEditingController _controller = TextEditingController()
    ..text = firstValue
    ..selection = TextSelection.collapsed(offset: firstValue.length);

  void _convert() {
    if (isFromImperialToMetric) {
      setState(() {
        secondValue = Converter.convertFromImperialToMetric(
                double.parse(firstValue), firstUnit, secondUnit)
            .toString();
      });
    } else {
      setState(() {
        secondValue = Converter.convertFromMetricToImperial(
                double.parse(firstValue), secondUnit, firstUnit)
            .toString();
      });
    }
  }

  void swapUnits() {
    setState(() {
      tempUnitList = secondUnitList;
      secondUnitList = firstUnitList;
      firstUnitList = tempUnitList;

      tempChoosenUnit = secondUnit;
      secondUnit = firstUnit;
      firstUnit = tempChoosenUnit;

      tempVal = secondValue;
      secondValue = firstValue;
      firstValue = tempVal;
      _controller.text = firstValue;

      isFromImperialToMetric = !isFromImperialToMetric;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // SizedBox(height: 16, width: 60),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _controller,
                      onChanged: (text) {
                        if (text == '') {
                          text = '0';
                        }
                        setState(() {
                          firstValue = text;
                        });
                        _convert();
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter value',
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DropdownButton<String>(
                        value: firstUnit,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            firstUnit = value!;
                          });
                          _convert();
                        },
                        items: firstUnitList,
                      )),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 70, 0),
                  child: IconButton(
                      onPressed: swapUnits,
                      icon: const Icon(Icons.swap_vert),
                      color: Colors.deepPurple),
                ),
              ),
            ]),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: secondValue.toString()),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Result value',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DropdownButton<String>(
                        value: secondUnit,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            secondUnit = value!;
                          });
                          _convert();
                        },
                        items: secondUnitList,
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(60.0),
                    child: ElevatedButton(
                        onPressed: null, child: Text("SHOW HISTORY")),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
