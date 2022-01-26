import 'dart:async';

import 'package:flutter/material.dart';

Future<DateTime> dateTimeModalBottomSheet(DateTime datetime, BuildContext context) async {
  final FixedExtentScrollController _yearController = FixedExtentScrollController(initialItem: datetime.year);
  final FixedExtentScrollController _monthController = FixedExtentScrollController(initialItem: datetime.month - 1);

  int year = datetime.year;
  int month = datetime.month;
  int day = datetime.day;
  var result = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
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
                                    controller: _yearController,
                                    itemExtent: 35,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      year = i;
                                    },
                                    children: List<Widget>.generate(year + 50, (index) => Text('${index}')),
                                  ),
                                ),
                                Text("년"),
                                Container(
                                  width: 50,
                                  height: 100,
                                  child: ListWheelScrollView(
                                    controller: _monthController,
                                    itemExtent: 35,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      month = i + 1;
                                    },
                                    children: List<Widget>.generate(12, (index) => Text('${index + 1}')),
                                  ),
                                ),
                                Text("월"),
                              ],
                            ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border(left: BorderSide(width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text(
                              'OK',
                            ),
                            onPressed: () {
                              Navigator.pop(context, DateTime.utc(year, month, day));
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
    return DateTime.utc(year, month, day);
  } else {
    return result;
  }
}
