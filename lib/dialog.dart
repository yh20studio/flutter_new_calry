import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/listItems.dart';

Future<String> alertDialog(BuildContext context, String title) async {
  String result = await showDialog(
    barrierDismissible: false,
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7 <= 300
                    ? MediaQuery.of(context).size.width * 0.7
                    : 300,
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.4, color: Colors.black),
                        )),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text("$title",
                                style: Theme.of(context).textTheme.subtitle1))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text('OK',
                                style: Theme.of(context).textTheme.subtitle1),
                            onPressed: () {
                              Navigator.pop(context, 'ok');
                            },
                          ),
                        ))
                      ],
                    )
                  ],
                )),
          ));
    },
  );
  return result;
}

Future<String> twoChoiceDialog(BuildContext context, String title) async {
  String result = await showDialog(
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7 <= 300
                    ? MediaQuery.of(context).size.width * 0.7
                    : 300,
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.4, color: Colors.black),
                        )),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text("$title",
                                style: Theme.of(context).textTheme.subtitle1))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text('취소',
                                style: Theme.of(context).textTheme.subtitle1),
                            onPressed: () {
                              Navigator.pop(context, "cancel");
                            },
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text('OK',
                                style: Theme.of(context).textTheme.subtitle1),
                            onPressed: () {
                              Navigator.pop(context, 'ok');
                            },
                          ),
                        ))
                      ],
                    )
                  ],
                )),
          ));
    },
  );
  return result;
}

Future<TimeDuration> duraionChoiceDialog(
    BuildContext context, TimeDuration timeDuration) async {
  final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: timeDuration.hour!);
  final FixedExtentScrollController _minController =
      FixedExtentScrollController(initialItem: timeDuration.min!);
  final FixedExtentScrollController _secController =
      FixedExtentScrollController(initialItem: timeDuration.sec!);
  var result = await showDialog(
    barrierDismissible: true,
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7 <= 300
                    ? MediaQuery.of(context).size.width * 0.7
                    : 300,
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.4, color: Colors.black),
                        )),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 50,
                                  height: 100,
                                  child: ListWheelScrollView(
                                    controller: _hourController,
                                    itemExtent: 35,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      timeDuration.hour = i;
                                    },
                                    children: List<Widget>.generate(
                                        13, (index) => Text('${index}')),
                                  ),
                                ),
                                Text("시간"),
                                Container(
                                  width: 50,
                                  height: 100,
                                  child: ListWheelScrollView(
                                    controller: _minController,
                                    itemExtent: 35,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      timeDuration.min = i;
                                    },
                                    children: List<Widget>.generate(
                                        60, (index) => Text('${index}')),
                                  ),
                                ),
                                Text("분"),
                                Container(
                                  width: 50,
                                  height: 100,
                                  child: ListWheelScrollView(
                                    controller: _secController,
                                    itemExtent: 35,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      timeDuration.sec = i;
                                    },
                                    children: List<Widget>.generate(
                                        60, (index) => Text('${index}')),
                                  ),
                                ),
                                Text("초"),
                              ],
                            ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text('OK',
                                style: Theme.of(context).textTheme.subtitle1),
                            onPressed: () {
                              Navigator.pop(context, timeDuration);
                            },
                          ),
                        ))
                      ],
                    )
                  ],
                )),
          ));
    },
  );
  if (result == null) {
    return timeDuration;
  } else {
    return result;
  }
}
