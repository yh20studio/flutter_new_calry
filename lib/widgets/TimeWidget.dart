import 'package:flutter/material.dart';

Widget hourMinuteTimeWidget({required TimeOfDay? timeOfDay, required BuildContext context}) {
  return Text(
    "${timeOfDay!.hour}시 ${timeOfDay.minute}분",
    style: TextStyle(color: Colors.black),
  );
}

Widget meridiemHourMinuteTimeWidget({required TimeOfDay? timeOfDay, required BuildContext context}) {
  String meridiem = timeOfDay!.hour < 12 ? "오전" : "오후";
  return Text(
    timeOfDay.minute == 0
        ? "${meridiem} ${timeOfDay.hour < 12 ? timeOfDay.hour : timeOfDay.hour - 12}시"
        : "${meridiem} ${timeOfDay.hour < 12 ? timeOfDay.hour : timeOfDay.hour - 12}시 ${timeOfDay.minute}분",
    style: TextStyle(color: Colors.black),
  );
}

Widget meridiemHourMinuteTimeSmallWidget({required TimeOfDay? timeOfDay, required BuildContext context}) {
  String meridiem = timeOfDay!.hour < 12 ? "오전" : "오후";
  return Text(
    timeOfDay.minute == 0
        ? "${meridiem} ${timeOfDay.hour < 12 ? timeOfDay.hour : timeOfDay.hour - 12}시"
        : "${meridiem} ${timeOfDay.hour < 12 ? timeOfDay.hour : timeOfDay.hour - 12}시 ${timeOfDay.minute}분",
    style: TextStyle(color: Colors.black, fontSize: 14),
  );
}
