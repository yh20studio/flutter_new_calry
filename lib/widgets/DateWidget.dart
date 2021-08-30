import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';

Widget monthDayDateWidget(
    {required DateTime? datetime, required BuildContext context}) {
  // widget layout for listview items
  return Text("${datetime!.month}월 ${datetime.day}일");
}
