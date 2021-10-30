import 'package:flutter/material.dart';
import 'package:flutter_new_calry/listItems.dart';

Widget weekdayWidget({required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(
        7,
        (i) => Expanded(
            child: Center(
                child: i == 0
                    ? Text(
                        "${weekdayList[i]}",
                        style: TextStyle(color: Colors.red),
                      )
                    : Text("${weekdayList[i]}")))).toList(),
  );
}
